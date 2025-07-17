import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../viewmodels/personal_info_viewmodel.dart';

class InterestsCategoriesView extends StatelessWidget {
  const InterestsCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PersonalInfoViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCategoryChips(
          context: context,
          title: AppStrings.education
          ,
          selected: vm.education,
          options: [
            AppStrings.nios
            ,
            AppStrings.onlineLearning
            ,
            AppStrings.schoolLife
            ,
            AppStrings.collegeStudents
            ,
            AppStrings.tuitionAndCoaching
            ,
            AppStrings.skillDevelopment
            ,
            AppStrings.competitiveExams
            ,
            AppStrings.spokenEnglish
            ,
            AppStrings.studyAbroad

          ],
          categoryKey: AppStrings.educationKey
          ,
        ),
        buildCategoryChips(
          context: context,
          title: AppStrings.technology
          ,
          selected: vm.technology,
          options: [
            AppStrings.smartphones
            ,
            AppStrings.mobileApps
            ,
            AppStrings.gadgets
            ,
            AppStrings.internetTips
            ,
            AppStrings.digitalPayments
            ,
            AppStrings.aiAndChatgpt
            ,
            AppStrings.codingProgramming
            ,
            AppStrings.webDevelopment
            ,
            AppStrings.ethicalHacking

          ],
          categoryKey:AppStrings.technologyKey
          ,
        ),
        buildCategoryChips(
          context: context,
          title:AppStrings.lifestyle
          ,
          selected: vm.lifestyle,
          options: [
            AppStrings.travel
            ,
            AppStrings.fashion
            ,
            AppStrings.healthAndFitness
            ,
            AppStrings.beautyAndMakeup
            ,
            AppStrings.foodAndCooking
            ,
            AppStrings.photography
            ,
            AppStrings.parenting
            ,
            AppStrings.journaling
            ,
            AppStrings.minimalism

          ],
          categoryKey: 'lifestyle',
        ),
        buildCategoryChips(
          context: context,
          title: AppStrings.entertainment
          ,
          selected: vm.entertainment,
          options: [
            AppStrings.gaming,
            AppStrings.anime,
            AppStrings.cartoons,
            AppStrings.memes,
            AppStrings.movies,
            AppStrings.tvShows,
            AppStrings.standUpComedy,
            AppStrings.music,
            AppStrings.dance,

          ],
          categoryKey: 'entertainment',
        ),
        buildCategoryChips(
          context: context,
          title: AppStrings.careerAndMoney
          ,
          selected: vm.careerAndMoney,
          options: [
            AppStrings.governmentJobs,
            AppStrings.partTimeJobs,
            AppStrings.freelancing,
            AppStrings.internships,
            AppStrings.workFromHome,
            AppStrings.sideHustles,
            AppStrings.resumeBuilding,
            AppStrings.businessIdeas,
            AppStrings.investmentAndSavings

          ],
          categoryKey: 'careerAndMoney',
        ),
        buildCategoryChips(
          context: context,
          title: AppStrings.socialMedia
          ,
          selected: vm.socialMedia,
          options: [
            AppStrings.whatsappStatus,
            AppStrings.youtubeShortsVlogs,
            AppStrings.instagramReels,
            AppStrings.tiktok,
            AppStrings.snapchatContent,
            AppStrings.sharechatContent,
            AppStrings.influencerMarketing,
            AppStrings.affiliateMarketing,
            AppStrings.bloggingVlogging,

          ],
          categoryKey: 'socialMedia',
        ),
        buildCategoryChips(
          context: context,
          title: AppStrings.personalGrowth
          ,
          selected: vm.personalGrowth,
          options: [
            AppStrings.motivation,
            AppStrings.timeManagement,
            AppStrings.goalSetting,
            AppStrings.selfDiscipline,
            AppStrings.publicSpeaking,
            AppStrings.meditationMindfulness,
            AppStrings.productivityTools,
            AppStrings.readingBookSummaries,

          ],
          categoryKey: 'personalGrowth',
        ),
        buildCategoryChips(
          context: context,
          title: AppStrings.regionalAndCultural
          ,
          selected: vm.regionalAndCultural,
          options: [
            AppStrings.malayalamContent,
            AppStrings.tamilContent,
            AppStrings.hindiContent,
            AppStrings.keralaLocalNews,
            AppStrings.tamilNaduUpdates,
            AppStrings.indianCultureFestivals,
            AppStrings.villageLife,
            AppStrings.artHandicrafts

          ],
          categoryKey: 'regionalAndCultural',
        ),
        buildCategoryChips(
          context: context,
          title: AppStrings.wellbeingAndAwareness
          ,
          selected: vm.wellbeingAndAwareness,
          options: [
            AppStrings.mentalHealth,
            AppStrings.physicalWellness,
            AppStrings.cleanLiving,
            AppStrings.womensHealth,
            AppStrings.youthGuidance,
            AppStrings.toxicParentingAwareness,
            AppStrings.studyMotivation

          ],
          categoryKey: 'wellbeingAndAwareness',
        ),
        const SizedBox(height: 16),
        Text('${vm.totalSelectedInterests} selected'),
      ],
    );
  }

  Widget buildCategoryChips({
    required BuildContext context,
    required String title,
    required Set<String> selected,
    required List<String> options,
    required String categoryKey,
  }) {
    final vm = Provider.of<PersonalInfoViewModel>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((item) {
            final isSelected = selected.contains(item);
            return ChoiceChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (_) => vm.toggleCategoryInterest(categoryKey, item),
              selectedColor: Colors.deepPurple.shade100,
            );
          }).toList(),
        ),
      ],
    );
  }
}
