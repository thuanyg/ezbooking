import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/data/models/organizer.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';
import 'package:ezbooking/presentation/pages/home/home_page.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/events_organizer_bloc.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/events_organizer_event.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/events_organizer_state.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/organizer_bloc.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/organizer_event.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/organizer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class OrganizerProfilePage extends StatefulWidget {
  final String organizerID;

  const OrganizerProfilePage({super.key, required this.organizerID});

  @override
  State<OrganizerProfilePage> createState() => _OrganizerProfilePageState();
}

class _OrganizerProfilePageState extends State<OrganizerProfilePage> {
  late OrganizerBloc organizerBloc;
  late EventsOrganizerBloc eventsOrganizerBloc;

  @override
  void initState() {
    super.initState();
    organizerBloc = BlocProvider.of<OrganizerBloc>(context);
    eventsOrganizerBloc = BlocProvider.of<EventsOrganizerBloc>(context);
    organizerBloc.add(FetchOrganizer(widget.organizerID));
    eventsOrganizerBloc.add(FetchEventsOrganizer(widget.organizerID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<OrganizerBloc, OrganizerState>(
        builder: (context, state) {
          if (state is OrganizerLoading) {
            return Center(
              child: Lottie.asset(
                "assets/animations/loading.json",
                height: 80,
              ),
            );
          }

          if (state is OrganizerLoaded) {
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(state.organizer),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildContactSection(state.organizer),
                      const SizedBox(height: 16),
                      _buildSocialMediaSection(state.organizer),
                      const SizedBox(height: 16),
                      _buildEventsSection(),
                      const SizedBox(height: 16),
                      _buildAdditionalInfoSection(),
                    ]),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSliverAppBar(Organizer organizer) {
    return SliverAppBar(
      expandedHeight: 210,
      pinned: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      foregroundColor: Colors.white,
      backgroundColor: AppColors.primaryColor,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Kiểm tra trạng thái cuộn
          final double appBarHeight = constraints.biggest.height;
          final bool isCollapsed = appBarHeight <= kToolbarHeight + MediaQuery.of(context).padding.top;

          return FlexibleSpaceBar(
            title: isCollapsed
                ? Text(
              organizer.name ?? 'Anonymous Organizer',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            )
                : null, // Khi chưa cuộn đến giới hạn, không hiển thị tiêu đề.
            centerTitle: true,
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Organizer Avatar + Name
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        backgroundImage: organizer.avatarUrl != null && organizer.avatarUrl != ""
                            ? CachedNetworkImageProvider(organizer.avatarUrl!)
                            : null,
                        child: organizer.avatarUrl == null || organizer.avatarUrl == ""
                            ? const Icon(
                          Icons.person,
                          size: 42,
                          color: Colors.white,
                        )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        organizer.name ?? 'Anonymous Organizer',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactSection(Organizer organizer) {
    return Card(
      elevation: 3,
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
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildContactRow(
              icon: Icons.email_outlined,
              text: organizer.email ?? 'No email provided',
            ),
            const SizedBox(height: 8),
            _buildContactRow(
              icon: Icons.phone_outlined,
              text: organizer.phoneNumber ?? 'No phone number provided',
            ),
            const SizedBox(height: 8),
            _buildContactRow(
              icon: Icons.location_on_outlined,
              text: organizer.address ?? 'No address provided',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialMediaSection(Organizer organizer) {
    return Card(
      elevation: 3,
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
              'Social Media',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (organizer.website != null)
                  _buildSocialButton(
                    icon: Icons.language,
                    onPressed: () => _launchURL(organizer.website!),
                  ),
                if (organizer.facebook != null)
                  _buildSocialButton(
                    icon: Icons.facebook,
                    onPressed: () => _launchURL(organizer.facebook!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildEventsSection() {
    return Card(
      elevation: 3,
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
              'My Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: BlocBuilder<EventsOrganizerBloc, EventsOrganizerState>(
                builder: (context, state) {
                  if (state is EventsOrganizerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is EventsOrganizerLoaded) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.events.length,
                      itemBuilder: (context, index) {
                        final event = state.events[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              EventDetail.routeName,
                              arguments: event.id,
                            );
                          },
                          child: Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: 12),
                            child: Card(
                              elevation: 3,
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
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        color: AppColors.primaryColor,
        size: 36,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Card(
      elevation: 3,
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
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Passionate event organizer dedicated to creating memorable experiences. With years of experience in event management, we strive to bring unique and exciting events to our community.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
