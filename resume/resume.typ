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
    positions: ("MSc Computer Science and Engineering Student",)
  ),
  profile-picture: image("profile.png"),
  date: datetime.today().display(),
  paper-size: "a4",
  font: "Avenir",
  header-font: "Avenir",
)

= Education

#resume-entry(
  title: "Lunds tekniska högskola",
  location: "Master of Science in Computer Science and Engineering",
  date: "2021 - 2026",
)

#resume-entry(
  title: "University of British Columbia",
  location: "Exchange Semester in Computer Science and Engineering",
  date: "Fall 2024",
)

= Experience

#resume-entry(
  title: "App Developer",
  location: "Combain Mobile",
  date: "Jan 2024 - Present",
)
#resume-item[
  - Maintained Combain's mobile apps across various programming languages, quickly adapting to different project structures. Technologies used include Jetpack Compose, Flutter, SwiftUI, and Objective-C.
  - Developed a local-first version of Combain's positioning solutions for Android and iOS, employing ANN models with ONNX Runtime for on-device positioning using Wi-Fi, Bluetooth, and GPS.
]

#resume-entry(
  title: "Self-employed",
  location: "Evercode AB",
  date: "Aug 2022 - Present",
)
#resume-item[
  - Founded and operated an IT consulting business, gaining valuable insights into business management, including employee costs, taxation, and regulations.
  - Secured and managed multiple consulting contracts, handling negotiations and preparing price quotes.
]

#resume-entry(
  title: "Fullstack Developer",
  location: "Recruto",
  date: "Sep 2020 - Jan 2024",
)
#resume-item[
  - Maintained Recruto's web app using PHP, TypeScript, Node.js, MySQL, and Rust.
  - Enhanced system stability with on-premise Grafana, Loki, Prometheus, and Sentry.
  - Achieved 77x faster bulk email send-outs by implementing a RabbitMQ queue system.
  - Built a scalable notification system (Email, SMS, Web Push, mobile push) using Rust.
  - Developed and maintained the Recruto mobile app for iOS and Android in C\# (Xamarin Forms).
]

#resume-entry(
  title: "Teaching Assistant",
  location: "LTH",
  date: "Fall 2022 & 2023",
)
#resume-item[
  - Introductory Course in Programming
  - Secondary Course in Programming
]

#resume-entry(
  title: "Event Coordinator",
  location: "Arkad",
  date: "Fall 2023",
)
#resume-item[
  - Assisted in organizing the Arkad career fair, coordinating logistics and company engagement.
  - Managed communications with companies, coordinated food deliveries, and led a team of volunteers.
]

= Projects

#resume-entry(
  title: "Obsidian LaTeX OCR Plugin",
  location: [#link("https://github.com/Hugo-Persson/obsidian-ocrlatex")[github.com/Hugo-Persson/obsidian-ocrlatex]],
  date: "",
)
#resume-item[
  - More than 4300 downloads and 21 stars on GitHub
  - Built with TypeScript for the Obsidian Markdown editor
  - Converts images of math formulas into LaTeX format
]

#resume-entry(
  title: "DNS CLI Tool",
  location: [#link("https://github.com/Hugo-Persson/godaddy-cli-tools")[github.com/Hugo-Persson/godaddy-cli-tools]],
  date: "",
)
#resume-item[
  - Developed in Rust to manage DNS subdomains via CLI
  - Automatically updates DNS records when public IP changes
  - Supports subdomain registration and deletion from the CLI
]

= Skills

#resume-skill-item(
  "Programming Languages",
  (strong("TypeScript"), strong("Rust"), strong("Java"), "C", "C++", "C#", "PHP", "Scala", "Swift", "Kotlin", "Python", "Dart", "Lua", "HTML/CSS"),
)

#resume-skill-item(
  "Technologies",
  (strong("Docker"), strong("Git"), "Linux", "NGINX", "Traefik", "RabbitMQ", "Grafana", "Loki", "Prometheus", "GitHub Actions", "MQTT"),
)

#resume-skill-item(
  "Frameworks",
  (strong("Next.js"), strong("Flutter"), "Express", "Nest.js", "SvelteKit", "SwiftUI", "React Native", "Jetpack Compose"),
)

#resume-skill-item(
  "Currently Learning",
  ("IoT", "Embedded Programming"),
)

= Languages

#resume-skill-item(
  "Languages",
  (strong("Swedish") + " (Native)", strong("English") + " (Fluent)"),
)

= Interests

#resume-skill-item(
  "Interests",
  ("Traveling", "Fitness", "Running", "Nature", "Cooking", "Home Automation"),
)
