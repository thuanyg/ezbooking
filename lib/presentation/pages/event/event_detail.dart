import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
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
import 'package:ezbooking/presentation/pages/event/bloc/fetch_comment_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_comment_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_comment_state.dart';
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
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventDetail extends StatefulWidget {
  static const String routeName = "EventDetail";

  const EventDetail({super.key});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late ScrollController scrollController;
  late EventDetailBloc eventDetailBloc;
  late FavoriteBloc favoriteBloc;
  late CommentBloc commentBloc;
  late FetchCommentBloc fetchCommentBloc;
  late UserInfoBloc userInfoBloc;

  final mapService = GoogleMapService();

  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    eventDetailBloc = BlocProvider.of<EventDetailBloc>(context);
    userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    commentBloc = BlocProvider.of<CommentBloc>(context);
    fetchCommentBloc = BlocProvider.of<FetchCommentBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? eventID = ModalRoute.of(context)?.settings.arguments as String?;
      eventDetailBloc.add(FetchEventDetail(eventID ?? ""));
      fetchCommentBloc.add(FetchComments(eventID: eventID ?? ""));
    });
  }

  // void _onScroll() {
  //   if (scrollController.offset > scrollController.position.maxScrollExtent) {}
  //   if (scrollController.offset <= scrollController.position.minScrollExtent) {}
  // }

  @override
  void dispose() {
    favoriteBloc.add(ResetFavoriteEvent());
    eventDetailBloc.reset();
    commentBloc.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<EventDetailBloc, EventDetailState>(
          builder: (context, state) {
            if (state is EventDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
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
                      background: buildHeader(context, state.event),
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
              child: MainElevatedButton(
                width: MediaQuery.of(context).size.width - 48,
                textButton: "BUY TICKET (\$${state.event.ticketPrice})",
                iconName: "ic_button_next.png",
                onTap: () => Navigator.pushNamed(
                  context,
                  TicketBookingPage.routeName,
                  arguments: state.event,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                    avatarImage: "ic_location.png",
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
                                  onTap: () {
                                    showGeneralDialog(
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
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.7,
                                                width: double.infinity,
                                                child: PhotoViewGallery.builder(
                                                  pageController:
                                                      PageController(
                                                          initialPage: index),
                                                  onPageChanged: (index) {},
                                                  itemCount:
                                                      event.imageUrls.length,
                                                  builder: (context, index) {
                                                    return PhotoViewGalleryPageOptions(
                                                      imageProvider:
                                                          CachedNetworkImageProvider(
                                                              event.imageUrls[
                                                                  index]),
                                                      initialScale:
                                                          PhotoViewComputedScale
                                                                  .contained *
                                                              0.8,
                                                      heroAttributes:
                                                          PhotoViewHeroAttributes(
                                                              tag: event
                                                                      .imageUrls[
                                                                  index]),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
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
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Customer reviews",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      commentBloc.rating = rating;
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder(
                    bloc: commentBloc,
                    builder: (context, state) {
                      if (state is CommentSuccess) {
                        state.comment.userModel = userInfoBloc.user;
                        fetchCommentBloc.addComment(state.comment);
                        commentController.text = "";
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
                                    }
                                  },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              height: 48,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: state is CommentLoading
                                    ? Colors.grey
                                    : AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: state is CommentLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(),
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
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is FetchCommentsSuccess) {
                        if (state.comments.isEmpty) {
                          return const Text("No comments.");
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

  SizedBox buildHeader(BuildContext context, Event event) {
    return SizedBox(
      height: 268,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 240,
                child: ImageHelper.loadNetworkImage(
                  event.thumbnail ?? "",
                  width: double.maxFinite,
                  fit: BoxFit.fill,
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
            child: buildHeaderStickyWidget(),
          )
        ],
      ),
    );
  }
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

Widget buildHeaderStickyWidget() {
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
    child: Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Stack(
            children: [
              CircleAvatar(
                child: ImageHelper.loadAssetImage(
                    "${assetImageLink}ic_avatar.png",
                    height: 34,
                    width: 34),
              ),
              Positioned(
                left: 24,
                child: CircleAvatar(
                  child: ImageHelper.loadAssetImage(
                      "${assetImageLink}ic_avatar.png",
                      height: 34,
                      width: 34),
                ),
              ),
              Positioned(
                left: 48,
                child: CircleAvatar(
                  child: ImageHelper.loadAssetImage(
                      "${assetImageLink}ic_avatar.png",
                      height: 34,
                      width: 34),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Text(
            "20+ Going",
            style: AppStyles.h5
                .copyWith(color: AppColors.primaryColor, fontSize: 16),
          ),
        ),
        StandardElevatedButton(textButton: "Attend"),
        const SizedBox(width: 16),
      ],
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
                  onPressed: () => Navigator.of(context).pop(),
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
