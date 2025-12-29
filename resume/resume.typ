#import "@preview/modern-cv:0.9.0": *

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

MSc Computer Science & Engineering student with 5+ years of experience building production software across mobile, backend, and web.
Strong in TypeScript and Rust, with hands-on experience in iOS (Swift/SwiftUI), Android (Kotlin/Jetpack Compose), and cross-platform stacks.
Comfortable owning features end-to-end, improving reliability with observability, and optimizing systems for performance.

= Education

#resume-entry(
  title: "Lund University (LTH)",
  location: box[MSc Computer Science & Engineering (Exp. 2026)],
  date: "2021 – 2026",
)

#resume-entry(
  title: "University of British Columbia (UBC)",
  location: "Exchange Semester, Computer Science and Engineering",
  date: "Fall 2024",
)

= Experience

#resume-entry(
  title: "CTO",
  location: "Nordic Kinetics AB",
  date: "Mar 2025 – Present",
)
#resume-item[
  - First engineering hire at a med-tech startup building a tremor monitoring platform for Essential Tremor and Parkinson’s disease.
  - Built end-to-end products across mobile, watchOS, and clinician/researcher dashboards (data capture → analysis-ready exports → UI).
  - Implemented Apple Watch sensor integrations, including the CMMovementDisorderManager API.
  - Partnered with clinicians and researchers to support study execution and iterate on product requirements.
  - Contributed to regulatory readiness, including work toward an FDA 510(k) submission and CE certification.
]
#resume-entry(
  title: "Head of IT",
  location: "ARKAD — Scandinavia’s Largest Career Fair",
  date: "2024 – 2025",
)
#resume-item[
  - Led development of the ARKAD mobile app, backend, and supporting services used to run the career fair.
  - Set technical direction and feature priorities with the leadership group, aligning engineering work with organizational needs and event timelines.
  - Managed the IT organization (frontend + backend), working through team leads/coordinators to unblock delivery and make architecture/technology decisions.
  - Communicated status, risks, and technical trade-offs to cross-functional stakeholders to ensure smooth execution of the event.
]


#resume-entry(
  title: "Mobile Developer",
  location: "Combain Mobile",
  date: "Jan 2024 – Jan 2026",
)
#resume-item[
  - Maintained and shipped features across iOS and Android apps, adapting quickly to different codebases and architectures.
  - Worked across SwiftUI/Objective-C, Jetpack Compose, and Flutter depending on product needs.
  - Developed a local-first, on-device positioning prototype using Wi-Fi, Bluetooth, and GPS with ANN models running via ONNX Runtime.
]

#resume-entry(
  title: "Full-Stack Developer",
  location: "Recruto",
  date: "Sep 2020 – Jan 2024",
)
#resume-item[
  - Built and maintained features in a production web platform using PHP, TypeScript, Node.js, and MySQL; added Rust services for performance-critical components.
  - Improved bulk email throughput by 77× by introducing a RabbitMQ-based queue + worker architecture.
  - Built a multi-channel notification system (Email, SMS, Web Push, Mobile Push) in Rust with retries and provider abstraction.
  - Improved reliability and incident response by introducing/maintaining observability tooling (Grafana, Prometheus, Loki, Sentry).
  - Developed and maintained the iOS/Android app using C\# (Xamarin.Forms).
]

#resume-entry(
  title: "Founder & Consultant",
  location: "Evercode AB",
  date: "Aug 2022 – Present",
)
#resume-item[
  - Founded and run an IT consulting business delivering software projects end-to-end (scoping, estimation, implementation, delivery).
  - Managed client communication, requirements clarification, and technical decision-making across multiple engagements.
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

