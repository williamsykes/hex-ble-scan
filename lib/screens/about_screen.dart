import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex_ble_scan/theme/text_styles.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> openLocalResume() async {
    try {
      final byteData = await rootBundle.load('assets/resume.pdf');

      final tempDir = await getTemporaryDirectory();

      final file = File('${tempDir.path}/WilliamSykes_Resume.pdf');

      await file.writeAsBytes(byteData.buffer.asUint8List());

      await OpenFile.open(file.path);
    } catch (e) {
      debugPrint('Error opening local resume PDF: $e');
    }
  }

  Widget _buildHighlightCard(String text) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            text,
            style: TextStyles.white16Medium,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildSkillsSection(
      BuildContext context, String label, List<String> skills) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map((skill) => Chip(
                    label: Text(
                      skill,
                      style: TextStyles.blackMedium,
                    ),
                    backgroundColor: Colors.grey[300],
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final linkStyle = theme.textTheme.bodyMedium?.copyWith(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(title: const Text('About William Sykes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Download Resume Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: openLocalResume,
                icon: const Icon(Icons.download),
                label: const Text('Download Resume'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyles.white18Bold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Info Card
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('William Sykes',
                        style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 8),
                    Text('Intermediate Full-stack Software Developer',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('Location: Cape Town, South Africa',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey[800])),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () =>
                          _launchURL('mailto:williamsykesthe3rd@gmail.com'),
                      child: Text('Email: williamsykesthe3rd@gmail.com',
                          style: linkStyle),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => _launchURL('tel:+27715356617'),
                      child: Text('Phone: +27 71 535 6617', style: linkStyle),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () =>
                          _launchURL('https://github.com/williamsykes'),
                      child: Text('GitHub: github.com/williamsykes',
                          style: linkStyle),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => _launchURL(
                          'https://www.linkedin.com/in/thewilliamsykes'),
                      child: Text('LinkedIn: linkedin.com/in/thewilliamsykes',
                          style: linkStyle),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Summary
            _buildSectionTitle(context, 'Summary'),
            Text(
              'Full stack developer with 5 years of experience building and shipping web, mobile, and backend applications. Expert in React (TypeScript), .NET Core (C#), and Flutter (Dart). Proven track record of owning projects end-to-end - from clean UIs and robust APIs to scalable databases and live deployments.',
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),

            const SizedBox(height: 30),

            // Education
            _buildSectionTitle(context, 'Education'),
            Text(
              'Bachelor of Science in Mathematical Sciences (Computer Science)\n'
              'Stellenbosch University\n'
              '2016 – 2020',
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),

            const SizedBox(height: 30),

            // Experience
            _buildSectionTitle(context, 'Experience'),
            Text(
              'Intermediate Full stack Developer\nThinkNinjas\n2020 – Present\n\n'
              'ThinkNinjas is a software development company, focused on building internal web and mobile applications for a diverse range of clients. '
              'As a full-stack developer, I am responsible for building, deploying and maintaining these applications to support business processes.\n',
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),

            // Highlights
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                'Highlights',
                style:
                    theme.textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ),

            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildHighlightCard(
                      'Built scalable full-stack applications using React, Flutter, and .NET Core, including both public-facing tools and internal enterprise systems.'),
                  _buildHighlightCard(
                      'Built optimized relational database architectures with indexing strategies, stored procedures, and triggers to ensure high performance and data consistency across web and mobile applications.'),
                  _buildHighlightCard(
                      'Cut monthly third-party API costs by consolidating fragmented calls, eliminating redundant requests, and implementing record-level filtering - eliminating thousands of daily API calls and freeing up server resources for core application functions.'),
                  _buildHighlightCard(
                      'Reduced Google Cloud Storage expenses by developing an API-driven system to flag stale records and automate migration from Standard to Archive storage - balancing cost-efficiency with data retention requirements.'),
                  _buildHighlightCard(
                      'Added automated GitLab CI/CD pipelines to optimize deployment processes, reduce production bugs and minimize application downtime.'),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Skills
            _buildSectionTitle(context, 'Skills'),
            _buildSkillsSection(context, 'Client-side', [
              'React',
              'TypeScript',
              'JavaScript',
              'Redux',
              'Flutter',
              'Dart',
              'HTML5',
              'SCSS',
              'Material-UI',
              'Responsive Design',
              'Mobile-first Design',
            ]),
            _buildSkillsSection(context, 'Server-side', [
              '.NET Core',
              'C#',
              'EF Core',
              'JWT/OAuth2',
              'MySQL',
              'Firestore',
              'Firebase',
              'RESTful APIs',
            ]),
            _buildSkillsSection(context, 'Development & Operations', [
              'XUnit',
              'Moq',
              'GIT',
              'Google Cloud Platform',
              'GitLab',
              'GitLab CI/CD',
              'YAML',
              'NPM',
              'Android & iOS App Deployment',
            ]),
          ],
        ),
      ),
    );
  }
}
