import 'package:cached_network_image/cached_network_image.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/data/models/organizer.dart';
import 'package:ezbooking/presentation/pages/organizer/page/organizer_page.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/organizer/organizer_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllOrganizersScreen extends StatelessWidget {
  const AllOrganizersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final organizerListBloc = BlocProvider.of<OrganizerListBloc>(context);
    organizerListBloc.fetchOrganizers();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'All Organizers',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: const _OrganizerListView(),
    );
  }
}

class _OrganizerListView extends StatelessWidget {
  const _OrganizerListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizerListBloc, OrganizerListState>(
      builder: (context, state) {
        if (state is OrganizerListLoading) {
          return _buildLoadingIndicator();
        }

        if (state is OrganizerListFailure) {
          return _buildErrorWidget(state.error);
        }

        if (state is OrganizerListSuccess) {
          return _buildOrganizerGrid(state.organizers);
        }

        return const Center(child: Text('No data available'));
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          SizedBox(height: 16),
          const Text(
            'Failed to load organizers',
            style: TextStyle(
                color: Colors.red, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizerGrid(List<Organizer> organizers) {
    return organizers.isEmpty
        ? _buildEmptyState()
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.82,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: organizers.length,
            itemBuilder: (context, index) {
              return _OrganizerCard(organizer: organizers[index]);
            },
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off_outlined,
              size: 80, color: AppColors.primaryColor.withOpacity(0.5)),
          SizedBox(height: 16),
          Text(
            'No Organizers Found',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          const Text(
            'There are currently no organizers in the system.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}

class _OrganizerCard extends StatelessWidget {
  final Organizer organizer;

  const _OrganizerCard({Key? key, required this.organizer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              OrganizerProfilePage(organizerID: organizer.id ?? ""),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: organizer.avatarUrl != null
                      ? CachedNetworkImageProvider(organizer.avatarUrl!)
                      : null,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                  child: organizer.avatarUrl == null
                      ? Icon(Icons.person,
                          size: 50, color: AppColors.primaryColor)
                      : null,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      organizer.name ?? 'Unnamed Organizer',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      organizer.email ?? 'No email',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
