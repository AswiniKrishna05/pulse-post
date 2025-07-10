import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          title: 'Education',
          selected: vm.education,
          options: [
            'NIOS',
            'Online Learning',
            'School Life',
            'College Students',
            'Tuition & Coaching',
            'Skill Development',
            'Competitive Exams (NEET, UPSC, SSC)',
            'Spoken English',
            'Study Abroad'
          ],
          categoryKey: 'education',
        ),
        buildCategoryChips(
          context: context,
          title: 'Technology',
          selected: vm.technology,
          options: [
            'Smartphones',
            'Mobile Apps',
            'Gadgets',
            'Internet Tips',
            'Digital Payments',
            'AI & ChatGPT',
            'Coding / Programming',
            'Web Development',
            'Ethical Hacking'
          ],
          categoryKey: 'technology',
        ),
        buildCategoryChips(
          context: context,
          title: 'Lifestyle',
          selected: vm.lifestyle,
          options: [
            'Travel',
            'Fashion',
            'Health & Fitness',
            'Beauty & Makeup',
            'Food & Cooking',
            'Photography',
            'Parenting',
            'Journaling',
            'Minimalism'
          ],
          categoryKey: 'lifestyle',
        ),
        buildCategoryChips(
          context: context,
          title: 'Entertainment',
          selected: vm.entertainment,
          options: [
            'Gaming (Mobile/PC/Console)',
            'Anime',
            'Cartoons',
            'Memes & Funny Videos',
            'Movies',
            'TV Shows',
            'Stand-up Comedy',
            'Music & Singing',
            'Dance & Reels'
          ],
          categoryKey: 'entertainment',
        ),
        buildCategoryChips(
          context: context,
          title: 'Career & Money',
          selected: vm.careerAndMoney,
          options: [
            'Government Jobs',
            'Part-time Jobs',
            'Freelancing',
            'Internships',
            'Work From Home',
            'Side Hustles',
            'Resume Building',
            'Business Ideas',
            'Investment & Savings'
          ],
          categoryKey: 'careerAndMoney',
        ),
        buildCategoryChips(
          context: context,
          title: 'Social Media',
          selected: vm.socialMedia,
          options: [
            'WhatsApp Status',
            'YouTube Shorts / Vlogs',
            'Instagram Reels',
            'TikTok (if regionally used)',
            'Snapchat Content',
            'ShareChat Content',
            'Influencer Marketing',
            'Affiliate Marketing',
            'Blogging & Vlogging'
          ],
          categoryKey: 'socialMedia',
        ),
        buildCategoryChips(
          context: context,
          title: 'Personal Growth',
          selected: vm.personalGrowth,
          options: [
            'Motivation',
            'Time Management',
            'Goal Setting',
            'Self-Discipline',
            'Public Speaking',
            'Meditation / Mindfulness',
            'Productivity Tools',
            'Reading / Book Summaries'
          ],
          categoryKey: 'personalGrowth',
        ),
        buildCategoryChips(
          context: context,
          title: 'Regional & Cultural',
          selected: vm.regionalAndCultural,
          options: [
            'Malayalam Content',
            'Tamil Content',
            'Hindi Content',
            'Kerala Local News',
            'Tamil Nadu Updates',
            'Indian Culture & Festivals',
            'Village Life',
            'Art & Handicrafts'
          ],
          categoryKey: 'regionalAndCultural',
        ),
        buildCategoryChips(
          context: context,
          title: 'Wellbeing & Awareness',
          selected: vm.wellbeingAndAwareness,
          options: [
            'Mental Health',
            'Physical Wellness',
            'Clean Living',
            "Women's Health",
            'Youth Guidance',
            'Toxic Parenting Awareness',
            'Study Motivation'
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
