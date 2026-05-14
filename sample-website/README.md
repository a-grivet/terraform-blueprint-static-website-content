# Sample Website Content

This directory contains a sample static website for testing the Your Organization Static Website Blueprint infrastructure.

## Contents

```
sample-website/
├── index.html          # Main homepage
├── 404.html           # Custom error page
├── css/
│   └── style.css      # Stylesheet
├── js/
│   └── script.js      # JavaScript functionality
└── README.md          # This file
```

## Features

### Homepage (index.html)
- **Hero Section** - Eye-catching gradient hero with badges and CTAs
- **Status Section** - Real-time infrastructure status cards
- **Architecture Overview** - Detailed component descriptions
- **Features Section** - Key capabilities and benefits
- **Technical Specifications** - Infrastructure and security specs
- **Contact Section** - Documentation and support links
- **Responsive Design** - Mobile-friendly layout

### Styling (css/style.css)
- Modern CSS variables for theming
- Responsive grid layouts
- Smooth animations and transitions
- Mobile-first design approach
- Consistent spacing and typography

### Functionality (js/script.js)
- Smooth scrolling navigation
- Active section highlighting
- Intersection Observer animations
- Dynamic timestamp display
- Utility functions

### Error Page (404.html)
- Custom 404 error page
- Animated error display
- Auto-redirect option
- Consistent branding

## Deployment

### Using the deployment script:

```bash
# Deploy to DEV environment
./deploy-content.sh dev ./sample-website

# Deploy to PROD environment
./deploy-content.sh prod ./sample-website
```

### Manual deployment:

```bash
# Sync to S3 bucket
aws s3 sync ./sample-website s3://YOUR-BUCKET-NAME/ \
  --delete \
  --cache-control "public, max-age=31536000"

# Invalidate CloudFront cache
aws cloudfront create-invalidation \
  --distribution-id YOUR-DISTRIBUTION-ID \
  --paths "/*"
```

## Customization

### Branding
- Update colors in CSS variables (`:root` section)
- Replace domain names and environment badges
- Modify logo and icons

### Content
- Edit `index.html` for content changes
- Update architecture diagrams and descriptions
- Customize feature cards and specifications

### Styling
- Modify `css/style.css` for design changes
- Adjust responsive breakpoints
- Customize animations and transitions

## Testing

### Local Testing

```bash
# Using Python's built-in server
cd sample-website
python3 -m http.server 8000

# Or using Node.js http-server
npx http-server ./sample-website -p 8000

# Then open: http://localhost:8000
```

### Browser Testing
- Test on Chrome, Firefox, Safari, Edge
- Verify mobile responsiveness
- Check all navigation links
- Test smooth scrolling
- Verify animations

## Performance Optimization

The website is optimized for:
- **Fast Loading** - Minimal dependencies, inline critical CSS
- **Caching** - Cache-Control headers set by deployment script
- **Compression** - Gzip/Brotli compression via CloudFront
- **CDN** - Global distribution through CloudFront
- **Mobile** - Responsive images and layouts

## Browser Support

- Chrome (last 2 versions)
- Firefox (last 2 versions)
- Safari (last 2 versions)
- Edge (last 2 versions)
- Mobile browsers (iOS Safari, Chrome Mobile)

## License

Copyright © 2026 Your Organization. All rights reserved.
Internal use only.
