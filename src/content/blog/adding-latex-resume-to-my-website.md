---
title: How I wrote and published my resume as PDF to my website
description: >-
  A quick showcase of how I created my resume in Latex. 
  I will show of my Latex workflow on my mac and how I added this resume to my website. 
  I will show how I auto compile and publish the resume as a PDF with github actions
pubDate: 2024-10-25T00:00:00.000Z
tags:
  - latex
  - github-actions
keywords: []
draft: false
cover: ./images/publish-to-homebrew.png
---

## Goals

The main goal of the resume is to condense my personal website [hugopersson.com](https://hugopersson.com) to a one page PDF document. Many recruiters prefer this to get a quick overview of what I have to offer.
It is also required for general job applications. So my goal was to create a setup that covers these requirements

- Easy to edit and maintain
- Creates one page PDF file
- Local development
- Plain text
- Summarizes:
  - Experience
  - Education
  - Skills
- Accessible from my website

## Solution

To do this I chose to use Latex to write my CV. This allows me to have a lot of customization options and being able to truly fit my use case, something I couldn't do with for example markdown.
Latex allows me to write in plain text in my editor of choice. I also have the ability to create abstractions to avoid duplication of formatting.

To integrate with my website I decided to use GitHub Actions to automaticly compile the Latex to a PDF file and push it to the GitHub repository
for my website that will later be deployed automaticly to Cloudflare pages.
This ensures my website to always be up to date and allows me to quickly to quickly make edits to my resume without needing to locally compile.
for example I can open GitHub web editor change a small section then commit+push directly in my browser and this being reflected on my website.

## Creating LaTEX document

To get started with the LaTEX layout I looked online for a template to use and found [this amazing template](https://www.overleaf.com/latex/templates/altacv-template/trgqjpwnmtgv) from LianTze Lim that I decided to use.

I downloaded the Source Code and created a new directory `resume` in the root of my website. Then I inputed all my information and got a really nice looking resume.

## Publishing

To publish I setup this github actions

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

Then I added a link to the resume on the index of my website next to all the other links

```astro
<IconLink href="/cv.pdf">
  <FileText stroke-width={strokeWidth} class={iconClasses} />
</IconLink>
```

## Result

For the result you can find the resume at [hugopersson.com/cv.pdf](https://hugopersson.com/cv.pdf)
