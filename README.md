# [Data Science Teaching and Learning Lab (DSTL) Website](dstl-lab.github.io)
The Data Science Teaching and Learning Lab (DSTL, pronounced “distill”) at UCSD conducts research studies and prototypes novel tools for teaching and learning data science. The overarching goal of our group is to discover how instructors use (or struggle to use!) software tools to accomplish the many tasks of teaching, and design new tools that can improve the lives of data science instructors everywhere.
## Getting Started Instructions
1. Follow [these instructions](https://jekyllrb.com/docs/installation/) for installing Jekyll.
2. Run `bundle install` to install the reuqired dependencies.
3. Run `bundle exec jekyll serve` to run the Jekyll server.

## Publishing a blog post

1. Create a branch for your post; do not edit `main` directly.
2. Add `_posts/YYYY-MM-DD-your-post-title.md` (create `_posts` if needed).
   Use the publication date in the filename and include this front matter:

   ```markdown
   ---
   title: "Your post title"
   author: "Your name"
   excerpt: "A short summary for the blog listing."
   ---

   Briefly explain the project and why it matters.

   ## The question

   What problem are you investigating?

   ## Our approach

   Explain the method or prototype, with figures or examples where useful.

   ## Findings and limitations

   Describe the evidence and what it does not establish.

   ## Next steps

   What remains to be explored?
   ```

   For multiple authors, list their names together in `author`.
   For a photo and expandable author profile, add a member entry to
   `_data/blog_authors.yml` with `photo`, `role`, `bio`, and an optional
   `website`, then reference its key with `author_id: minchan-kim` in the post.
   Keep `author` as the display name. The profile opens on hover or by activating
   the author's name with a click, tap, or keyboard. Omit `author_id` for a
   plain byline (including a post with multiple authors).
   Optionally add `topic: "Teaching"`, `cover: /assets/images/blog/your-image.png`,
   and `cover_alt: "Description of the cover image"` to the front matter.
   Covers appear above the card title; use a wide image (ideally 720 × 400).
   Posts without a cover still display as text cards.
   Store images in `assets/images/blog/` and include meaningful alt text:
   `![Description of the image](/assets/images/blog/your-image.png)`.
   For captioned figures, use `<figure markdown="0"><img src="/assets/images/blog/your-image.png"
   alt="Description"><figcaption>Figure 1. Explain what the reader should notice.</figcaption></figure>`.
   Optional resource links appear below the article summary using the existing
   `links` front-matter field:

   ```yaml
   links:
     - name: Paper
       url: https://example.org/paper
     - name: Demo
       url: https://example.org/demo
     - name: Code
       url: https://github.com/your-org/your-project
   ```

   Include only resources that exist; the section headings above are a writing
   guide, not required fields.
3. Preview locally with `bundle exec jekyll serve` and visit `/blog/`.
   Check the article, author, date, summary, images, and mobile layout.
4. Open a pull request to `main` and request review from another lab member.
   Resolve their feedback before merging.
5. Once approved, merge the pull request. The post appears on the public site
   after the GitHub Pages deployment succeeds, and is included in the RSS feed.

Posts use the site's shared layout and appear newest first at `/blog/`.
Article URLs are `/blog/your-post-title/`. Future-dated posts are excluded
until a site build runs after their publication date; merging does not schedule
a future build. Use today's date or an earlier date when publishing now.

To keep a post out of the generated site, add `published: false` to its front
matter. Preview it with `bundle exec jekyll serve --unpublished`, and remove
that field before publishing. This is not private storage: files and pull
requests remain visible if the repository is public.

### Toggle the sample post

The included `_posts/2026-09-20-test-blog.md` is disabled by default with
`published: false`. Normal builds exclude it from the blog, article pages,
and RSS feed.

- Show it locally: `bundle exec jekyll serve --unpublished`.
- Hide it locally: restart with `bundle exec jekyll serve`.
- Publish it deliberately: change its `published` field to `true` in a pull
  request. Replace the sample content before doing this.

The preview option shows all unpublished posts; it does not change their saved
publication settings. Keep production builds on the normal command.

Review is the lab's publishing convention. To enforce approval before merging,
a repository administrator must configure a branch rule requiring pull requests
and at least one approval for `main`.

Run the blog smoke check with `bundle exec ruby scripts/check_blog.rb`.
It builds temporary sample posts without adding them to the live site.
