require 'tmpdir'
require 'fileutils'
require 'jekyll'
require 'nokogiri'

# Exercise the rendered blog, including ordering and unpublished content.
Dir.mktmpdir('dstl-blog-check') do |dir|
  dir = File.realpath(dir)
  source = File.join(dir, 'source')
  destination = File.join(dir, 'site')
  FileUtils.mkdir_p(source)
  root = File.expand_path('..', __dir__)
  %w[_config.yml _includes _layouts _sass index.md blog.html feed.xml].each do |name|
    path = File.join(root, name)
    FileUtils.cp_r(path, source) if File.exist?(path)
  end
  build = lambda do
    Dir.chdir(source) do
      Jekyll::Site.new(Jekyll.configuration(
        'source' => source, 'destination' => destination, 'quiet' => true,
        'url' => 'https://example.test', 'repository' => 'dstl-lab/dstl-lab.github.io'
      )).process
    end
  end
  build.call
  blog_path = File.join(destination, 'blog/index.html')
  abort 'Blog page was not generated' unless File.exist?(blog_path)
  abort 'Missing empty state' unless File.read(blog_path).include?('Posts are coming soon.')

  FileUtils.mkdir_p(File.join(source, '_posts'))
  FileUtils.mkdir_p(File.join(source, '_data'))
  File.write(File.join(source, '_data/blog_authors.yml'), "second:\n  photo: /assets/images/second.jpg\n  role: Project lead\n  bio: Studies how people learn data science.\n  website: https://example.test/author\n")
  {
    '2024-01-01-older.md' => "title: Older post\nauthor: First Author\nexcerpt: Earlier summary",
    '2024-02-01-newer.md' => "title: Newer post\nauthor: Second Author\nauthor_id: second\nexcerpt: Latest summary\ntopic: Lab notes\ncover: /assets/images/blog/test-blog.svg\ncover_alt: Writing, reviewing, and sharing an idea\nlinks:\n  - name: Code\n    url: https://example.test/code",
    '2024-03-01-hidden.md' => "title: Hidden post\npublished: false"
  }.each do |name, metadata|
    File.write(File.join(source, '_posts', name), "---\n#{metadata}\n---\n\n## Article body\n\nExample content.\n\n<figure markdown=\"0\">\n<img src=\"/figure.svg\" alt=\"Example diagram\">\n<figcaption>Figure 1. Example caption.</figcaption>\n</figure>\n")
  end
  build.call
  blog = Nokogiri::HTML(File.read(blog_path))
  titles = blog.css('.blog-entry h2').map(&:text)
  abort 'Posts must appear newest first, excluding unpublished posts' unless titles == ['Newer post', 'Older post']
  abort 'Missing post summary or author' unless blog.text.include?('Latest summary') && blog.text.include?('Second Author')
  cover = blog.at_css('.blog-entry img')
  abort 'Missing cover image or alt text' unless cover && cover['src'] == '/assets/images/blog/test-blog.svg' && cover['alt'] == 'Writing, reviewing, and sharing an idea'
  abort 'Missing topic label' unless blog.at_css('.blog-entry__topic')&.text == 'Lab notes'
  profile = blog.at_css('details.author-profile')
  abort 'Missing author photo and expandable profile' unless profile&.at_css('summary img[src="/assets/images/second.jpg"]') && profile.text.include?('Studies how people learn data science.')
  abort 'Author control must not be nested in the article link' unless profile.ancestors('a').empty?
  abort 'Missing author website' unless profile.at_css('a[href="https://example.test/author"]')
  abort 'Posts without a cover should not render a broken image' unless blog.css('.blog-entry').last.css('img').empty?
  article = Nokogiri::HTML(File.read(File.join(destination, 'blog/newer/index.html')))
  abort 'Missing article byline or date' unless article.text.include?('Second Author') && article.at_css('time[datetime^="2024-02-01T"]')
  abort 'Missing article author photo' unless article.at_css('.post-meta__byline img[src="/assets/images/second.jpg"]')
  abort 'Missing return link' unless article.at_css('.post__back[href="/blog/"]')&.text == 'Back to blog'
  abort 'Missing resource link' unless article.at_css('.post-meta__links a[href="https://example.test/code"]')&.text == 'Code'
  homepage = Nokogiri::HTML(File.read(File.join(destination, 'index.html')))
  abort 'Blog article controls leaked onto homepage' if homepage.at_css('.post__back, .post-meta__byline')
  abort 'Markdown body did not render' unless article.css('h2').any? { |h| h.text == 'Article body' }
  abort 'Figure caption did not render correctly' unless article.at_css('figure figcaption')&.text == 'Figure 1. Example caption.'
  abort 'Missing blog navigation' unless article.at_css('nav a[href="/blog/"]')
  abort 'Unpublished article was generated' if File.exist?(File.join(destination, 'blog/hidden/index.html'))
  abort 'Unpublished post leaked into RSS' if File.read(File.join(destination, 'feed.xml')).include?('Hidden post')
  puts 'Blog check passed: empty state, ordering, metadata, article, navigation, and unpublished posts.'
end
