#import "@preview/modern-cv:0.9.0": *

// Header with name and contact on pages 2+
#set page(header: context {
  if counter(page).get().first() > 1 [
    #text(size: 9pt, fill: rgb("#555"))[
      Hugo Persson #h(1fr) hugo.e.persson\@gmail.com | (+46) 72-240-6005
    ]
    #line(length: 100%, stroke: 0.5pt + rgb("#ddd"))
  ]
})

#show: resume.with(
  author: (
    firstname: "Hugo",
    lastname: "Persson",
    email: "hugo.e.persson@gmail.com",
    phone: "(+46) 72-240-6005",
    github: "Hugo-Persson",
    linkedin: "hugopersson7",
    address: "Lund, Sweden",
    positions: ("Software Engineer • MSc Computer Science & Engineering (Expected 2026)",)
  ),
  profile-picture: image("profile.png"),
  date: datetime.today().display(),
  paper-size: "a4",
  font: "Avenir",
  header-font: "Avenir",
)

= Summary

Software engineer with 5+ years of production experience across web, mobile, and infrastructure—currently CTO at a med-tech startup while completing my MSc.
Systems thinker and fast learner who thrives on rapid prototyping and solving complex problems across the full stack.
Career goal: transition into software architecture and technical leadership, designing systems at scale.

= Education

#resume-entry(
  title: "Lund University (LTH)",
  location: box[MSc Computer Science & Engineering (Exp. 2026)],
  date: "2021 – 2026",
)
#resume-item[
  - Thesis: Designing a high-throughput, memory-efficient lookup table for graph database ingestion—benchmarking data structures for concurrent access under RAM constraints.
  - Key takeaways: mathematical rigor, engineering thinking, and collaboration in team-based projects.
]

#resume-entry(
  title: "University of British Columbia (UBC)",
  location: "Exchange Semester, Computer Science and Engineering",
  date: "Fall 2024",
)
#resume-item[
  - Chose exchange to grow personally—improved soft skills, learned to present myself, and gained new perspectives on collaboration and work culture.
]

= Experience

#resume-entry(
  title: "CTO",
  location: "Nordic Kinetics AB",
  date: "Mar 2025 – Present",
)
#resume-item[
  - Responsible for all technical decisions in a 4-person med-tech startup (CEO, CFO, CTO, ML Engineer) building a tremor monitoring platform for Parkinson's and Essential Tremor.
  - Own the full technology stack: mobile apps (iOS/Android), watchOS, cloud architecture, and clinician dashboards—from architecture to implementation.
  - Partner with clinicians and researchers to translate clinical needs into product requirements and support study execution.
  - Contribute to regulatory strategy (FDA 510(k), CE certification), balancing engineering decisions with compliance constraints.
]
#resume-entry(
  title: "Head of IT",
  location: "ARKAD — Scandinavia’s Largest Career Fair",
  date: "2024 – 2025",
)
#resume-item[
  - Responsible for all technical decisions for the IT team (11 people) within a 300-person student organization and 22-person project group.
  - Owned app development strategy, architecture choices, and recruitment of new IT team members.
  - Delivered the ARKAD mobile app, backend, and supporting services used to run the career fair.
  - Represented IT in leadership meetings, translating technical trade-offs for non-technical stakeholders and contributing to organization-wide decisions.
]


#resume-entry(
  title: "Mobile Developer",
  location: "Combain Mobile",
  date: "Jan 2024 – Jan 2026",
)
#resume-item[
  - Mobile developer in a ~10-person team within a 30-person company specializing in positioning technology.
  - Responsible for maintaining and shipping features across iOS and Android apps (SwiftUI/Objective-C, Jetpack Compose, Flutter).
  - Led development of an on-device positioning prototype using Wi-Fi, Bluetooth, and GPS sensor fusion.
]

#resume-entry(
  title: "Full-Stack Developer",
  location: "Recruto",
  date: "Sep 2020 – Jan 2024",
)
#resume-item[
  - Full-stack developer in a 3-person dev team (6 total) at a recruitment platform company.
  - Responsible for end-to-end feature development across the web platform (PHP, TypeScript, Node.js, MySQL) and mobile app (Xamarin).
  - Owned DevOps infrastructure: containerized services with Docker, set up CI/CD pipelines, and built observability stack (Grafana, Prometheus, Loki, Sentry).
  - Designed and implemented a RabbitMQ-based queue architecture that improved bulk email throughput by 77×.
]

#resume-entry(
  title: "Founder & Consultant",
  location: "Evercode AB",
  date: "Aug 2022 – Present",
)
#resume-item[
  - Founded and run an IT consulting business delivering software projects end-to-end (scoping, estimation, implementation, delivery).
  - Client-facing work here developed the requirements-gathering and communication skills now used when collaborating with clinicians and researchers.
]

#resume-entry(
  title: "Teaching Assistant",
  location: "LTH",
  date: "Fall 2022 & Fall 2023",
)
#resume-item[
  - Teaching assistant for introductory and intermediate programming courses; supported labs, assignments, and student debugging sessions.
]


= Projects

#resume-entry(
  title: "Home Lab",
  location: [#link("https://github.com/Hugo-Persson/HomeLab")[github.com/Hugo-Persson/HomeLab]],
  date: "",
)
#resume-item[
  - Personal infrastructure running 20+ containerized services across multiple servers using Docker Compose.
  - Built sysadmin and DevOps skills: Traefik reverse proxy, Ansible automation, CI/CD pipelines, and monitoring (Grafana, Prometheus, Loki).
]

#resume-entry(
  title: "Obsidian LaTeX OCR Plugin",
  location: [#link("https://github.com/Hugo-Persson/obsidian-ocrlatex")[github.com/Hugo-Persson/obsidian-ocrlatex]],
  date: "",
)
#resume-item[
  - Open-source Obsidian plugin that converts images of math formulas into LaTeX (TypeScript).
  - 4,300+ downloads and 40 GitHub stars.
  - Designed for fast in-editor workflows with a focus on developer ergonomics and reliability.
]

#resume-entry(
  title: "DNS CLI Tool",
  location: [#link("https://github.com/Hugo-Persson/godaddy-cli-tools")[github.com/Hugo-Persson/godaddy-cli-tools]],
  date: "",
)
#resume-item[
  - Rust CLI for managing GoDaddy DNS subdomains and automating dynamic DNS updates when the public IP changes.
  - Supports creating/deleting records and updating DNS from the command line.
]

= Skills

#resume-skill-item(
  "Programming Languages",
  (strong("TypeScript"), strong("Rust"), strong("Kotlin"), strong("Swift"), strong("Java"), strong("Python"), "C#", "SQL", "C/C++", "PHP"),
)

#resume-skill-item(
  "Technologies",
  (strong("Git"), strong("Docker"), "Linux", "NGINX", "Traefik", "RabbitMQ", "Grafana", "Prometheus", "Loki", "Sentry", "GitHub Actions", "ONNX Runtime"),
)

#resume-skill-item(
  "Frameworks",
  (strong("Next.js"), strong("React Native"), strong("Flutter"), "Node.js (Express/NestJS)", "SwiftUI", "Jetpack Compose", "SvelteKit"),
)

#resume-skill-item(
  "Currently Learning",
  ("Embedded Systems", "IoT"),
)

= Languages

#resume-skill-item(
  "Languages",
  (strong("Swedish") + " (Native)", strong("English") + " (Fluent)"),
)

