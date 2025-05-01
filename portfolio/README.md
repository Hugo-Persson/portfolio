# Portfolio Project

This project is a personal portfolio built using Astro. It showcases my professional experience through detailed brag documents for each company I've worked with.

## Project Structure

- **src/content/experience/**: Contains Markdown files for each company's brag document.
  - `company-a.md`: Brag document for Company A.
  - `company-b.md`: Brag document for Company B.
  - `company-c.md`: Brag document for Company C.
  
- **src/layouts/**: Contains layout components for rendering the experience documents.
  - `ExperienceLayout.astro`: Defines the layout for displaying the content of the Markdown files.

- **src/pages/experience/**: Contains the dynamic route for rendering the experience documents.
  - `[slug].astro`: Renders the content of the Markdown files based on the slug parameter.

## Getting Started

1. Clone the repository.
2. Install the dependencies using `npm install`.
3. Run the development server with `npm run dev`.
4. Navigate to `/experience/company-a`, `/experience/company-b`, or `/experience/company-c` to view the brag documents.

## Contributing

Feel free to submit issues or pull requests if you have suggestions or improvements!