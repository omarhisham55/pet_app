import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_app/config/routes/routes.dart';
import 'package:pet_app/core/shared/components/containers/moded_container.dart';
import 'package:pet_app/core/shared/components/image_handler.dart';
import 'package:pet_app/core/shared/constants/constants.dart';
import 'package:pet_app/core/utils/colors.dart';
import 'package:pet_app/core/utils/image_manager.dart';
import 'package:pet_app/core/utils/strings.dart';
import 'package:pet_app/features/home/domain/entities/pet.dart';
import 'package:pet_app/features/home/presentation/cubit/pet_profile_cubit.dart';
import 'package:pet_app/features/home/presentation/pages/empty_profile.dart';
import 'package:pet_app/features/onbording/domain/entities/user.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class HomePageProfile extends StatelessWidget {
  const HomePageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetProfileCubit, PetProfileState>(
      builder: (context, state) {
        final cubit = context.read<PetProfileCubit>();
        final int petsLength = cubit.user?.ownedPets.length ?? 0;
        if (cubit.user == null) return Lottie.asset(LoadingLotties.paws);
        return petsLength != 0
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _petCarousel(context, cubit),
                    _gridView(context),
                  ],
                ),
              )
            : const EmptyProfileStartUp();
      },
    );
  }

  Widget _petCarousel(BuildContext context, PetProfileCubit cubit) {
    return BlocSelector<PetProfileCubit, PetProfileState, User?>(
      selector: (state) => cubit.user,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              MainStrings.drawerYourPets,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (state != null)
              Row(
                children: [
                  SmoothPageIndicator(
                    axisDirection: Axis.vertical,
                    controller: cubit.petProfilesCarouselController,
                    count: state.ownedPets.length,
                    effect: const ExpandingDotsEffect(
                      expansionFactor: 3,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 170,
                      child: StackedCardCarousel(
                        pageController: cubit.petProfilesCarouselController,
                        type: StackedCardCarouselType.cardsStack,
                        initialOffset: cubit
                            .petProfilesCarouselController.initialPage
                            .toDouble(),
                        items: state.ownedPets.map((pet) {
                          return _carouselPetItem(
                            context: context,
                            pet: pet,
                            cubit: cubit,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _carouselPetItem({
    required BuildContext context,
    required Pet pet,
    required PetProfileCubit cubit,
  }) {
    return GestureDetector(
      onTap: () {
        cubit.changePetProfileView(0);
        Constants.navigateTo(
          context,
          Routes.viewPetProfile,
          arguments: {'pet': pet},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: SharedModeColors.blue500,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(0, -4),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        height: 150,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pet.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    '${pet.category} | ${pet.breed}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            ClipOval(
              child: ImageHandler(
                imageBytes: pet.imgUrl,
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridView(BuildContext context) {
    Widget gridItem(context, List<Widget> items, Function() onTap) {
      return ModedContainer(
        onTap: onTap,
        borderRadius: 24,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        ),
      );
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: [
        gridItem(
          context,
          [
            Text(
              'Share profile',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Text(
              'Easily share your pet\'s profile or add a new one',
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.adaptive.arrow_forward),
            ),
          ],
          () => Constants.navigateTo(context, Routes.shareProfile),
        ),
        gridItem(
          context,
          [
            Image.asset(ProfileImages.nutrition),
            Text(
              'Nutrition',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
          () {
            PetProfileCubit.get(context).changePetProfileView(2);
            Constants.navigateTo(context, Routes.viewPetProfile);
          },
        ),
        gridItem(
          context,
          [
            Image.asset(ProfileImages.healthCard),
            Text(
              'Health Card',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
          () {
            PetProfileCubit.get(context).changePetProfileView(1);
            Constants.navigateTo(context, Routes.viewPetProfile);
          },
        ),
        gridItem(
          context,
          [
            Image.asset(ProfileImages.activities),
            Text(
              'Activities',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
          () {
            PetProfileCubit.get(context).changePetProfileView(3);
            Constants.navigateTo(context, Routes.viewPetProfile);
          },
        ),
      ],
    );
  }
}
