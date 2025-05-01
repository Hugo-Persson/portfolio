interface WorkExperience {
  company: string;
  role: string;
  start: string;
  end: string;
  description: string;
  logoImg: string;
  slug: string;
}

interface Education {
  university: string;
  educationName: string;
  period: string;
  description: string;
  logoImg: string;
  slug: string;
}

const WORK_EXPERIENCE: Record<string, WorkExperience> = {
    combain: {
        company: "Combain Mobile AB",
        role: "App Developer",
        start: "January 2024",
        end: "Present",
        description: "Leading the development of advanced mobile SDKs used globally for precise location lookup by scanning Wi-Fi and BLE devices with AI-based position estimation. Developed an application leveraging Android AR Core to train an artificial neural network model for location lookups. Transitioned the location lookup process from backend to on-device execution using ONNX runtime, significantly improving efficiency. Contributed to standalone applications using Flutter and native iOS technologies.",
        logoImg: "@images/combain-icon.png",
        slug: "combain"
    },
    recruto: {
        company: "Recruto",
        role: "Full-stack Developer",
        start: "September 2020",
        end: "January 2024",
        description: "Handled PHP Zend Framework 1 development, Xamarin Forms mobile development, and implemented DevOps workflows. Introduced Docker for containerization, utilized RabbitMQ for messaging, and set up Grafana + Loki + Prometheus observability stack. Managed MySQL databases for web and mobile applications, achieving seamless integration, efficient collaboration, and effective monitoring capabilities.",
        logoImg: "@images/recruto.webp",
        slug: "recruto"
    }
};

const EDUCATION: Record<string, Education> = {
    lundUniversity: {
        university: "Lund University",
        educationName: "Master of Science in Computer Science",
        period: "2020 - Present",
        description: "Currently pursuing my master's degree in Computer Science with a focus on AI and Software Engineering. Courses include Machine Learning, Software Engineering, Algorithms, Databases, Web Development, Networks, Operating Systems, and Security.",
        logoImg: "@images/lund_university.png",
        slug: "lund-university"
    },
    ubc: {
        university: "University of British Columbia",
        educationName: "Exchange Student in Computer Science",
        period: "Fall 2024",
        description: "Completed one term as an exchange student, focusing on advanced courses in AI, Machine Learning, Operating Systems, and Business Studies.",
        logoImg: "@images/ubc.png",
        slug: "ubc"
    }
};

export { WORK_EXPERIENCE, EDUCATION };
export type { WorkExperience, Education };