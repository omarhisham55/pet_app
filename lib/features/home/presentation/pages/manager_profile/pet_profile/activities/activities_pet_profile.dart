import 'package:flutter/material.dart';
import 'package:pet_app/config/routes/routes.dart';
import 'package:pet_app/core/shared/components/containers/moded_container.dart';
import 'package:pet_app/core/shared/constants/constants.dart';
import 'package:pet_app/core/utils/image_manager.dart';
import 'package:pet_app/features/home/presentation/pages/manager_profile/pet_profile/activities/activity_items/profile_activity_manager.dart';
import 'package:pet_app/features/home/presentation/pages/manager_profile/pet_profile/activities/activity_items/tricks.dart';
import 'package:pet_app/features/home/presentation/pages/manager_profile/pet_profile/activities/activity_items/walk.dart';

class ActivitiesPetProfile extends StatelessWidget {
  const ActivitiesPetProfile({super.key});

  static Map<String, dynamic> activities = {
    'Walks': const WalkActivity(),
    'Tricks': const TricksActivity(),
  };

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: activities.length,
      itemBuilder: (context, index) => _activityItem(
        context,
        activities.entries.toList()[index],
      ),
    );
  }

  Widget _activityItem(
    BuildContext context,
    MapEntry<String, dynamic> activity,
  ) {
    return ModedContainer(
      onTap: () => Constants.navigateTo(
        context,
        Routes.intoActivities,
        arguments: ProfileActivityArguments(
          subTitle: activity.key,
          body: activity.value,
        ),
      ),
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.zero,
      borderRadius: 22,
      child: Row(
        children: [
          Image.asset(ProfileImages.healthCard),
          Text(
            activity.key,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
