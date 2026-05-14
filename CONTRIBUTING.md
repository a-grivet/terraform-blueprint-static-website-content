# Static Website Blueprint - Contributing Guide

## Overview

Thank you for contributing to the Static Website Blueprint! This guide will help you get started.

## Getting Started

### Prerequisites

- Terraform >= 1.5.0
- AWS CLI >= 2.0
- Git
- Access to Your Organization AWS accounts

### Local Development Setup

1. Clone the repository:
```bash
git clone https://github.com/a-grivet/terraform-blueprint-static-website-content.git
cd terraform-blueprint-static-website-content
```

2. Install pre-commit hooks (recommended):
```bash
chmod +x deploy.sh deploy-content.sh
```

3. Set up AWS credentials:
```bash
aws configure
```

## Development Workflow

### Making Changes

1. Create a feature branch:
```bash
git checkout -b feature/your-feature-name
```

2. Make your changes to Terraform files

3. Format your code:
```bash
terraform fmt -recursive infrastructure/
```

4. Validate your changes:
```bash
cd infrastructure/environments/dev
terraform init -backend-config=backend.tfvars
terraform validate
```

5. Test in DEV environment:
```bash
./deploy.sh dev plan
./deploy.sh dev apply
```

### Code Standards

#### Terraform Style Guide

- Use 2-space indentation
- Use snake_case for resource and variable names
- Add comments for complex logic
- Group related resources in the same file
- Use meaningful resource names

#### File Organization

```
infrastructure/
├── modules/           # Reusable modules
│   └── <module>/
│       ├── main.tf    # Main resources
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md  # Module documentation
└── environments/      # Environment configs
    └── <env>/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── terraform.tfvars
        └── backend.tfvars
```

#### Commenting Standards

```hcl
# ============================================================================
# SECTION HEADER - Brief Description
# ============================================================================
# Detailed explanation of what this section does
# ============================================================================

# Single-line comment for simple explanations
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"  # Inline comment for specific attribute
}
```

### Testing

Before submitting a PR:

1. **Validate syntax**:
```bash
terraform validate
```

2. **Check formatting**:
```bash
terraform fmt -check -recursive
```

3. **Test in DEV**:
```bash
./deploy.sh dev plan
./deploy.sh dev apply
```

4. **Verify functionality**:
- Upload test content
- Check website accessibility
- Verify SSL certificate
- Test CloudFront caching

5. **Clean up** (if needed):
```bash
./deploy.sh dev destroy
```

## Pull Request Process

### Creating a Pull Request

1. Push your branch to GitHub:
```bash
git push origin feature/your-feature-name
```

2. Create a Pull Request:
- Target the `dev` branch
- Fill out the PR template
- Link related issues
- Request review from team members

### PR Requirements

- [ ] All tests pass
- [ ] Code is formatted (`terraform fmt`)
- [ ] Configuration is validated
- [ ] Changes are tested in DEV
- [ ] Documentation is updated
- [ ] CHANGELOG is updated (if applicable)

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested in DEV environment
- [ ] Plan output reviewed
- [ ] Apply successful
- [ ] Website functionality verified

## Checklist
- [ ] Code formatted with `terraform fmt`
- [ ] Configuration validated
- [ ] Documentation updated
- [ ] No sensitive data committed
```

### Review Process

1. Automated checks run (terraform validate, fmt)
2. Team member reviews code
3. Changes requested or approved
4. PR merged to `dev` branch
5. Automatic deployment to DEV (if configured)

## Commit Message Convention

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting (no logic changes)
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements

### Examples

```bash
# Feature
git commit -m "feat(cloudfront): add custom error responses for SPA support"

# Bug fix
git commit -m "fix(s3): correct bucket policy for CloudFront OAC"

# Documentation
git commit -m "docs(readme): add troubleshooting section"

# Refactoring
git commit -m "refactor(modules): extract logs module for reusability"
```

## Reporting Bugs

### Before Reporting

1. Check existing issues
2. Verify in latest version
3. Test in clean environment
4. Collect relevant logs

### Bug Report Template

```markdown
**Description**
Clear description of the bug

**To Reproduce**
1. Go to '...'
2. Run '...'
3. See error

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- Terraform version:
- AWS region:
- Environment (dev/prod):

**Logs**
```
Relevant log output
```

**Screenshots**
If applicable
```

## Suggesting Enhancements

### Enhancement Template

```markdown
**Problem Statement**
What problem does this solve?

**Proposed Solution**
How would you solve it?

**Alternatives Considered**
Other approaches you thought about

**Additional Context**
Any other relevant information
```

## Documentation

### Updating Documentation

When making changes, update:

1. **README.md** - Main documentation
2. **Module README** - Individual module docs
3. **CHANGELOG.md** - List of changes
4. **Code Comments** - Inline documentation

### Documentation Standards

- Use clear, concise language
- Include code examples
- Add diagrams for complex concepts
- Keep formatting consistent
- Link to AWS documentation when relevant

## Security

### Sensitive Data

**NEVER commit:**
- AWS credentials
- API keys
- Passwords
- Private keys
- Account IDs (when avoidable)

### Security Issues

Report security vulnerabilities privately to:
- Email: your-contact@example.com
- Don't open public issues for security problems

## Versioning

We use [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes

## Getting Help

- **GitHub Discussions**: Use for questions
- **GitHub Issues**: Use for bugs and features

## Acknowledgments

- AWS for excellent documentation
- HashiCorp for Terraform
- All contributors to this project

---

**Thank you for contributing to the Static Website Blueprint!** 🎉
