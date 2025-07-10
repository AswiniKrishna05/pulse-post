import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/personal_info_viewmodel.dart';

final Map<String, List<String>> interestCategories = {
  'Education': [
    'NIOS', 'Online Learning', 'School Life', 'College Students', 'Tuition & Coaching', 'Skill Development', 'Competitive Exams (NEET, UPSC, SSC)', 'Spoken English', 'Study Abroad'
  ],
  'Technology': [
    'Smartphones', 'Mobile Apps', 'Gadgets', 'Internet Tips', 'Digital Payments', 'AI & ChatGPT', 'Coding / Programming', 'Web Development', 'Ethical Hacking'
  ],
  'Lifestyle': [
    'Travel', 'Fashion', 'Health & Fitness', 'Beauty & Makeup', 'Food & Cooking', 'Photography', 'Parenting', 'Journaling', 'Minimalism'
  ],
  'Entertainment': [
    'Gaming (Mobile/PC/Console)', 'Anime', 'Cartoons', 'Memes & Funny Videos', 'Movies', 'TV Shows', 'Stand-up Comedy', 'Music & Singing', 'Dance & Reels'
  ],
  'Career & Money': [
    'Government Jobs', 'Part-time Jobs', 'Freelancing', 'Internships', 'Work From Home', 'Side Hustles', 'Resume Building', 'Business Ideas', 'Investment & Savings'
  ],
  'Social & Media': [
    'WhatsApp Status', 'YouTube Shorts / Vlogs', 'Instagram Reels', 'TikTok (if regionally used)', 'Snapchat Content', 'ShareChat Content', 'Influencer Marketing', 'Affiliate Marketing', 'Blogging & Vlogging'
  ],
  'Personal Growth': [
    'Motivation', 'Time Management', 'Goal Setting', 'Self-Discipline', 'Public Speaking', 'Meditation / Mindfulness', 'Productivity Tools', 'Reading / Book Summaries'
  ],
  'Regional & Cultural': [
    'Malayalam Content', 'Tamil Content', 'Hindi Content', 'Kerala Local News', 'Tamil Nadu Updates', 'Indian Culture & Festivals', 'Village Life', 'Art & Handicrafts'
  ],
  'Wellbeing & Awareness': [
    'Mental Health', 'Physical Wellness', 'Clean Living', 'Women\'s Health', 'Youth Guidance', 'Toxic Parenting Awareness', 'Study Motivation'
  ],
};

class InterestsCategoriesView extends StatelessWidget {
  const InterestsCategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PersonalInfoViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select your interests:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        ...interestCategories.entries.map((entry) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: entry.value.map((interest) => FilterChip(
                label: Text(interest),
                selected: vm.selectedInterests.contains(interest),
                onSelected: (_) => vm.toggleInterest(interest),
              )).toList(),
            ),
          ],
        )),
        const SizedBox(height: 16),
        Text('${vm.selectedInterests.length} selected'),
      ],
    );
  }
}
