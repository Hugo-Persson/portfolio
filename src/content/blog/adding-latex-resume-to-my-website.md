---
title: My Resume as a PDF to My Website Using LaTeX and GitHub Actions
description: >-
  A step-by-step guide on how I used LaTeX to create my resume and automated its publication to my website as a PDF using GitHub Actions. This article outlines my workflow on macOS, from creating the resume to deploying it automatically.
pubDate: 2024-10-25T00:00:00.000Z
tags:
  - latex
  - github-actions
keywords: []
draft: false
cover: ./images/cv-workflow.png
---

## Goals

My primary goal was to transform my personal website, [hugopersson.com](https://hugopersson.com) into a concise one-page PDF resume. Many recruiters prefer a single-page format to quickly assess candidates, and having an up-to-date resume is essential for general job applications. To meet these needs, I aimed to establish a setup that ensures:

- Easy maintenance and updates
- A single-page PDF format
- Local development options
- Plain text editing
- Summarizes:
  - Experience
  - Education
  - Skills
- Accessible from my website

## Solution

To achieve this, I chose LaTeX for creating my resume. LaTeX provides extensive customization options, allowing me to tailor the document to my specific needs—something that simpler formats like Markdown cannot offer. Additionally, LaTeX enables me to write in plain text, which I can easily edit in any text editor. I also have the flexibility to create reusable components, reducing repetitive formatting.

For seamless integration with my website, I set up GitHub Actions to automatically compile my LaTeX file into a PDF and deploy it to my site. The process involves pushing updates to my GitHub repository, which triggers an automated build and deployment to Cloudflare Pages. This setup ensures that my website always displays the latest version of my resume, allowing me to make quick edits directly on GitHub without needing a local compile. For example, I can open the GitHub web editor, adjust a section, commit, and see the changes reflected on my website.

## Creating LaTEX document

To get started with the LaTEX layout I looked online for a template to use and found [this amazing template](https://www.overleaf.com/latex/templates/altacv-template/trgqjpwnmtgv) from LianTze Lim that I decided to use.

I downloaded the Source Code and created a new directory `resume` in the root of my website. Then I inputed all my information and got a really nice looking resume.

## Publishing

To automate the publishing process, I configured the following GitHub Actions workflow:

```yml
name: Build LaTeX document
on:
  workflow_dispatch:
  push:
    paths:
      - "cv/**"
jobs:
  build_latex:
    runs-on: ubuntu-latest
    steps:
      - name: Set up Git repository
        uses: actions/checkout@v4
      - name: Compile LaTeX document
        uses: xu-cheng/latex-action@v3
        with:
          working_directory: ./resume
          root_file: ./mmayer.tex
      - name: Move PDF file to public directory
        run: mv ./resume/mmayer.pdf ./public/cv.pdf
      - name: Configure git user
        run: |
          git config --global user.name "github-actions[bot]"
          git config --global user.email "github-actions[bot]@users.noreply.github.com"
      - name: Add and commit the new file
        run: |
          git add ./public/cv.pdf
          git commit -m "Update cv.pdf"
      - name: Push changes
        run: git push
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

This action is triggered whenever I push changes to files within the cv directory. The workflow compiles the LaTeX document, moves the generated PDF to the public directory, commits the new version, and pushes it to my repository. The updated PDF is then deployed to Cloudflare Pages, keeping the resume on my website current.

Finally, I added a link to the resume on the main page of my website. This link is placed alongside other links in my site’s navigation, making it easy for visitors to find.

```astro
<IconLink href="/cv.pdf">
  <FileText stroke-width={strokeWidth} class={iconClasses} />
</IconLink>
```

## Result

The result is now live! You can view the resume at [hugopersson.com/cv.pdf](https://hugopersson.com/cv.pdf). This setup has made maintaining and sharing my resume straightforward, with updates reflected on my site almost instantly.
