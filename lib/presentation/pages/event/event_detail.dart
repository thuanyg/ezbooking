import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/services/google_map_service.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/comment_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/comment_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/comment_state.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_state.dart';
import 'package:ezbooking/presentation/pages/event/bloc/favorite_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/favorite_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_available_ticket_cubit.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_comment_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_comment_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_comment_state.dart';
import 'package:ezbooking/presentation/pages/event/bloc/going_event_cubit.dart';
import 'package:ezbooking/presentation/pages/home/home_page.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/events_organizer_bloc.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/events_organizer_event.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/events_organizer_state.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/ticket_booking_page.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_bloc.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:ezbooking/presentation/widgets/event_subinfo.dart';
import 'package:ezbooking/presentation/widgets/favorite.dart';
import 'package:ezbooking/presentation/widgets/organizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventDetail extends StatefulWidget {
  static const String routeName = "EventDetail";

  const EventDetail({super.key});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late ScrollController scrollController;

  // Bloc initialize
  late EventDetailBloc eventDetailBloc;
  late FavoriteBloc favoriteBloc;
  late CommentBloc commentBloc;
  late FetchCommentBloc fetchCommentBloc;
  late UserInfoBloc userInfoBloc;
  late GoingEventCubit goingEventCubit;
  late FetchAvailableTicketCubit availableTicketCubit;

  final mapService = GoogleMapService();

  final commentController = TextEditingController();

  bool isAddNewComment = false;

  List<Event>? eventsCache;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    eventDetailBloc = BlocProvider.of<EventDetailBloc>(context);
    userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    commentBloc = BlocProvider.of<CommentBloc>(context);
    fetchCommentBloc = BlocProvider.of<FetchCommentBloc>(context);
    goingEventCubit = BlocProvider.of<GoingEventCubit>(context);
    availableTicketCubit = BlocProvider.of<FetchAvailableTicketCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? eventID = ModalRoute.of(context)?.settings.arguments as String?;
      loadData(eventID);
    });
  }

  loadData(String? eventID) {
    eventDetailBloc.add(FetchEventDetail(eventID ?? ""));
    goingEventCubit.fetchGoingEvent(eventID ?? "");
    fetchCommentBloc.add(FetchComments(eventID: eventID ?? ""));
    availableTicketCubit.fetchAvailableTickets(eventID!);
  }

  @override
  void dispose() {
    favoriteBloc.add(ResetFavoriteEvent());
    eventDetailBloc.reset();
    commentBloc.reset();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("object");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<EventDetailBloc, EventDetailState>(
          builder: (context, state) {
            if (state is EventDetailLoading) {
              return Center(
                child: Lottie.asset(
                  "assets/animations/loading.json",
                  height: 80,
                ),
              );
            }

            if (state is EventDetailLoaded) {
              return CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 268,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      stretchModes: const [StretchMode.blurBackground],
                      background: buildHeader(
                        context,
                        state.event,
                        goingEventCubit,
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: buildHeaderSliver(state.event),
                  ),
                  SliverToBoxAdapter(
                    child: buildEventBody(state.event),
                  )
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: BlocBuilder(
        bloc: eventDetailBloc,
        builder: (context, state) {
          if (state is EventDetailLoaded) {
            return Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  // Shadow color with opacity
                  spreadRadius: 1,
                  // Spread the shadow
                  blurRadius: 16,
                  // Blur effect
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  // Shadow color with opacity
                  spreadRadius: 1,
                  // Spread the shadow|

                  blurRadius: 24,
                  // Blur effect
                  offset: const Offset(0, -10),
                ),
              ]),
              child: buildFab(state.event),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildFab(Event event) {
    bool isSoldOut = event.availableTickets <= 0;
    if (isSoldOut) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            const TicketAvailabilityCounter(
              availableTickets: 0,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Sold out",
                    style: AppStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    DateTime eventDateLocal = event.date.toLocal();
    if (eventDateLocal.isBefore(DateTime.now())) {
      return Container(
        clipBehavior: Clip.antiAlias,
        height: 56,
        width: MediaQuery.of(context).size.width - 48,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            "Event Ended",
            style: AppStyles.button.copyWith(color: Colors.white),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          BlocBuilder<FetchAvailableTicketCubit, int>(
            builder: (context, state) {
              return TicketAvailabilityCounter(
                availableTickets: state,
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.white,
              );
            },
          ),
          const SizedBox(width: 4),
          Expanded(
            child: MainElevatedButton(
              width: MediaQuery.of(context).size.width - 48,
              textButton: "BUY TICKET - \$${event.ticketPrice}",
              iconName: "ic_button_next.png",
              radius: BorderRadius.circular(10),
              onTap: () => Navigator.pushNamed(
                context,
                TicketBookingPage.routeName,
                arguments: event,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView buildEventBody(Event event) {
    Future<String?> eventAddressFuture = mapService.getFullAddress(
        lat: event.geoPoint!.latitude, long: event.geoPoint!.longitude);
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  EventSubInformation(
                    title: DateFormat('d MMMM').format(event.date),
                    subtitle: DateFormat('EEEE, h:mm a').format(event.date),
                    iconName: "ic_event.png",
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<String?>(
                    future: eventAddressFuture,
                    builder: (context, snapshot) {
                      return EventSubInformation(
                        title: event.location,
                        subtitle: snapshot.data ?? "Undefined",
                        iconName: "ic_location.png",
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Organizer(
                    id: event.organizer?.id ?? "",
                    avatarImage: event.organizer?.avatarUrl ?? "",
                    organizerName: event.organizer!.name!,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "About",
                      style: AppStyles.h5.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.description,
                    textAlign: TextAlign.justify,
                    style: AppStyles.h5.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 36,
              thickness: .3,
              color: Colors.grey.shade400,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Organization",
                      style: AppStyles.h5.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ImageHelper.loadAssetImage("assets/images/ic_marker.png"),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.organizer?.address ?? "Undefined",
                          maxLines: 1,
                          style: AppStyles.h5.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black87.withOpacity(.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ImageHelper.loadAssetImage("assets/images/ic_call.png"),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.organizer?.phoneNumber ?? "Undefined",
                          style: AppStyles.h5.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black87.withOpacity(.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ImageHelper.loadAssetImage("assets/images/ic_mail.png"),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.organizer?.email ?? "Undefined",
                          style: AppStyles.h5.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black87.withOpacity(.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 36,
              thickness: .3,
              color: Colors.grey.shade400,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Find us",
                      style: AppStyles.h5.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.facebook,
                          size: 36,
                          color: Color(0xff17907C),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: ImageHelper.loadAssetImage(
                          "assets/images/ic_youtube.png",
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: ImageHelper.loadAssetImage(
                          "assets/images/ic_linkedin.png",
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
              height: 36,
              thickness: .3,
              color: Colors.grey.shade400,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Images",
                      style: AppStyles.h5.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: event.imageUrls.isEmpty
                        ? const Center(
                            child: Text("Don't have any images to display ..."),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: event.imageUrls.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: InkWell(
                                  onTap: () async {
                                    await _showImageDialog(
                                        context, index, event.imageUrls);
                                  },
                                  child: ImageHelper.loadNetworkImage(
                                    event.imageUrls[index],
                                    radius: BorderRadius.circular(6),
                                    width: 120,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildEventsSection(event),
            const SizedBox(height: 8),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    "Customer reviews",
                    style: AppStyles.h5.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 24,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      commentBloc.rating = rating;
                    },
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder(
                    bloc: commentBloc,
                    builder: (context, state) {
                      if (state is CommentSuccess) {
                        if (isAddNewComment) {
                          state.comment.userModel = userInfoBloc.user;
                          fetchCommentBloc.addComment(state.comment);
                          commentController.text = "";
                          // Set flag
                          isAddNewComment = false;
                        }
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: TextField(
                                controller: commentController,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                                enabled: state is CommentLoading ? false : true,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Write a comment",
                                  hintMaxLines: 1,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                cursorColor: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: state is CommentLoading
                                ? null
                                : () {
                                    User? currentUser =
                                        FirebaseAuth.instance.currentUser;
                                    if (commentController.text.isNotEmpty) {
                                      String content = commentController.text;
                                      Comment comment = Comment(
                                        AppUtils.generateRandomString(6),
                                        currentUser!.uid,
                                        event.id!,
                                        Timestamp.now(),
                                        commentBloc.rating,
                                        content,
                                        null,
                                      );
                                      commentBloc
                                          .add(CommentAction(comment: comment));
                                      // Set flag
                                      isAddNewComment = true;
                                    }
                                  },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              height: 48,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: state is CommentLoading
                                    ? Lottie.asset(
                                        "assets/animations/loading.json",
                                        height: 48,
                                        width: 48,
                                      )
                                    : const Text(
                                        "SEND",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder(
                    bloc: fetchCommentBloc,
                    builder: (context, state) {
                      if (state is FetchCommentsLoading) {
                        return Center(
                          child: Lottie.asset(
                            "assets/animations/loading.json",
                            height: 80,
                          ),
                        );
                      }
                      if (state is FetchCommentsSuccess) {
                        if (state.comments.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.comments_disabled,
                                    size: 28,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Be the first to comment!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[400],
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.comments.length,
                          itemBuilder: (context, index) {
                            return buildCommentItem(state.comments[index]);
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.grey.shade100,
                              thickness: 0.8,
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<Event>> fetchEventsByCategory(Event event) async {
    final eventDocs = await FirebaseFirestore.instance
        .collection("events")
        .where("category", isEqualTo: event.category)
        .get();

    return eventDocs.docs.map((e) => Event.fromJson(e.data())).toList();
  }

  Widget _buildEventsSection(Event event) {
    if (eventsCache != null) {
      final events = eventsCache!;
      return Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Related Events',
                style: AppStyles.h5.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return GestureDetector(
                      onTap: () {
                        loadData(event.id);
                      },
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 12),
                        child: Card(
                          elevation: 1,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: event.thumbnail ?? "",
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      event.location,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${event.date.day}/${event.date.month}/${event.date.year}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    return FutureBuilder<List<Event>>(
      future: fetchEventsByCategory(event),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {}
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            List<Event> events = snapshot.data!;
            events.removeWhere((e) => e.id == event.id);
            eventsCache = events;
            return Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Related Events',
                      style: AppStyles.h5.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                EventDetail.routeName,
                                arguments: event.id,
                              );
                            },
                            child: Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 12),
                              child: Card(
                                elevation: 1,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: event.thumbnail ?? "",
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            event.location,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${event.date.day}/${event.date.month}/${event.date.year}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  Column buildCommentItem(Comment comment) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                comment.userModel?.avatarUrl ??
                    "https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg",
              ),
              radius: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                comment.userModel?.fullName ?? "Undefined",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            if (comment.userID == currentUser!.uid)
              const PopupMenuComment()
            else
              const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            RatingBar.builder(
              initialRating: comment.rating,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 16,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              ignoreGestures: true,
              onRatingUpdate: (value) {},
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                timeago.format(comment.createdAt.toDate()),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 6),
        Text(
          comment.content,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        )
      ],
    );
  }

  _showImageDialog(
      BuildContext context, int index, List<String> imageUrls) async {
    await showGeneralDialog(
      barrierDismissible: true,
      context: context,
      barrierLabel: '',
      pageBuilder: (context, _, __) {
        return SizedBox(
          child: Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.white,
              elevation: 3,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: double.infinity,
                child: PhotoViewGallery.builder(
                  wantKeepAlive: true,
                  pageController: PageController(initialPage: index),
                  itemCount: imageUrls.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider:
                          CachedNetworkImageProvider(imageUrls[index]),
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                      heroAttributes:
                          PhotoViewHeroAttributes(tag: imageUrls[index]),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox buildHeader(
      BuildContext context, Event event, GoingEventCubit goingEventBloc) {
    return SizedBox(
      height: 268,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 240,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      event.thumbnail ?? "",
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.55),
                      BlendMode.darken,
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: Text(
                    "Event Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: buildFavoriteButton(
                      eventID: event.id!,
                      bloc: favoriteBloc,
                    ),
                  ),
                ),
                const SizedBox(width: 12)
              ],
            ),
          ),
          Positioned(
            bottom: 2,
            left: 36,
            right: 36,
            child: buildHeaderStickyWidget(goingEventBloc, event),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PopupMenuComment extends StatefulWidget {
  const PopupMenuComment({
    super.key,
  });

  @override
  State<PopupMenuComment> createState() => _PopupMenuCommentState();
}

class _PopupMenuCommentState extends State<PopupMenuComment> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: const Icon(
        Icons.more_horiz,
        size: 18,
        color: Colors.black54,
      ),
      onSelected: (value) {
        if (value == 'edit') {
          // Perform editing action without setState
        } else if (value == 'delete') {
          // Perform delete action without affecting the state
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Text("Edit"),
              Expanded(
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Text("Delete"),
              Expanded(
                child: Icon(
                  Icons.delete,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget buildHeaderStickyWidget(GoingEventCubit bloc, Event event) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.grey, width: 0.05),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          // Shadow color with opacity
          spreadRadius: 1,
          // Spread the shadow
          blurRadius: 16,
          // Blur effect
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: BlocBuilder<GoingEventCubit, GoingEventState>(
                builder: (context, state) {
                  if (state is GoingEventSuccess) {
                    if (state.going.quantity == 0) {
                      return Icon(
                        Icons.join_full,
                        color: AppColors.primaryColor,
                        size: 30,
                      );
                    }
                    return Stack(
                      children: List.generate(
                        state.going.avatarUrls.length,
                        (index) {
                          return Positioned(
                            left: index * 12,
                            top: 0,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: CachedNetworkImageProvider(
                                state.going.avatarUrls[index],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<GoingEventCubit, GoingEventState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is GoingEventSuccess) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      textAlign: TextAlign.center,
                      state.going.quantity != 0
                          ? "${state.going.quantity}+ Going"
                          : "Join now",
                      style: AppStyles.h5.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          StandardElevatedButton(
            textButton: "Share",
            onTap: () async {
              try {
                String shareUrl = "https://htthuan.id.vn/event?id=${event.id}";

                await Share.share(
                  shareUrl,
                  subject: 'Share event to your social media!',
                );
              } catch (e) {
                print('Error sharing uri: $e');
              }
            },
          ),
        ],
      ),
    ),
  );
}

const double _maxHeaderExtent = 120.0;

class buildHeaderSliver extends SliverPersistentHeaderDelegate {
  final Event event;

  buildHeaderSliver(this.event);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var percent = shrinkOffset / _maxHeaderExtent;
    if (percent > 0.1) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: Container(
          color: AppColors.primaryColor,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "Event Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: buildFavoriteButton(
                      eventID: event.id!,
                      bloc: context.read<FavoriteBloc>(),
                    ),
                  ),
                ),
                const SizedBox(width: 12)
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text(
            event.name,
            maxLines: 2,
            style: AppStyles.h3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class TicketAvailabilityCounter extends StatelessWidget {
  final int availableTickets;
  final Color backgroundColor;
  final Color textColor;

  const TicketAvailabilityCounter({
    super.key,
    required this.availableTickets,
    this.backgroundColor = const Color(0xFF4A90E2),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.confirmation_number_outlined,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 2),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  // Define the slide animation
                  final position = Tween<Offset>(
                    begin: const Offset(0.0, 1.0), // Starts from below
                    end:
                        const Offset(0.0, 0.0), // Ends at its original position
                  ).animate(animation);

                  return SlideTransition(
                    position: position,
                    child: child,
                  );
                },
                child: Text(
                  availableTickets.toString(),
                  // Use a unique key for the child to trigger the animation
                  key: ValueKey<int>(availableTickets),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
