# GrowthGPT - AI Assistant Guidelines

## Project Philosophy

This is an **open-source first SaaS foundation**. Code must be:
- **Clean** - Well-structured, readable, maintainable
- **Modular** - Reusable components, clear separation of concerns
- **Scalable** - Built for growth, performance-conscious
- **SOLID** - Follow SOLID principles (Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion)
- **DRY** - Don't Repeat Yourself - avoid code duplication, extract reusable utilities
- **KISS** - Keep It Simple, Stupid - prefer simple solutions over complex ones
- **Minimal** - Write the least amount of code necessary to achieve the goal
- **Tested** - Comprehensive test coverage, isolated unit tests, integration tests
- **Reusable** - Leverage existing components, libraries, and open-source solutions before creating new ones
- **Isolated Development** - Develop features independently with minimal dependencies, enabling parallel work

## Core Principles for AI Assistants

### Autonomy & Decision Making
- **Operate autonomously where possible** - If the task is clear and you know the best approach, execute it without asking
- **Ask "what do you suggest?"** - If priority is unclear, propose your recommendation and execute it
- **Do what's asked; nothing more, nothing less** - Stay focused on the specific task

### File Management
- **NEVER create files unless absolutely necessary** for the goal
- **ALWAYS prefer editing existing files** over creating new ones
- **NEVER proactively create documentation** (*.md, README) unless explicitly requested
- **Use existing patterns** - Look at similar files before creating something new
- **Reuse components** - Check `src/components/`, `src/lib/`, and existing utilities before creating new ones
- **Leverage open source** - Use established libraries over custom implementations
- **Minimize code** - Write the shortest, simplest solution that solves the problem

## 🔐 SECURITY - CREDENTIALS & SECRETS

**⚠️ MANDATORY: Before ANY git commit, push, or publishing code, ALWAYS scan for exposed credentials:**

### Never Commit These Patterns:
- API keys: `AIzaSy*`, `sk-*`, `re_*` (Resend), `ak-*`/`as-*` (Modal)
- JWT tokens: `eyJ*` (Supabase service keys, etc.)
- Proxy credentials: `host:port:username:password` format
- Database connection strings with passwords
- `.env.local`, `.env.production`, or any file with real credentials

### Pre-Commit Checklist:
```bash
# ALWAYS run before committing:
git diff --staged | grep -iE '(api[_-]?key|secret|password|token|credentials).*[=:].*[a-zA-Z0-9]{20,}'
grep -rE '(AIzaSy|sk-[a-zA-Z0-9]{40}|re_[a-zA-Z0-9]{20}|eyJhbGc)' . --include='*.py' --include='*.ts' --include='*.js'
```

### Credentials Storage:
- **Local development**: `.env.local` (gitignored)
- **Production**: Environment variables in deployment platform
- **NEVER** hardcode credentials in source files

## Development Standards

### Code Quality & Maintainability:
- **STRONGLY prefer simple, clean, maintainable solutions** over clever or complex ones
- **Readability and maintainability are PRIMARY CONCERNS**, even at the cost of conciseness or performance
- **MATCH the style and formatting** of surrounding code, even if it differs from standard style guides
- **Consistency within a file** trumps external standards
- **NEVER make unrelated code changes** - if you notice something unrelated that should be fixed, document it rather than fixing immediately
- **PRESERVE code comments** - never remove comments unless you can PROVE they are actively false
- **Use evergreen naming** - never use temporal conventions like 'improved', 'new', 'enhanced', 'recently refactored'

## Quality Gates (Must Pass Before Proceeding)

### Before Committing
- [ ] TypeScript compiles: `npx tsc --noEmit`
- [ ] Lint passes: `npm run lint`
- [ ] Tests pass: `npm run test`
- [ ] Manual testing done
- [ ] No console.log/debugger statements
- [ ] No commented-out code (unless documented why)

### Before Creating PR
- [ ] All commits have clear messages
- [ ] Branch is up to date with main
- [ ] Build succeeds: `npm run build`
- [ ] All tests pass: `npm run test:all`
- [ ] E2E tests pass (if UI changes): `npm run test:e2e`
- [ ] No TypeScript errors
- [ ] No ESLint warnings
- [ ] Manual QA completed

## 🔍 Error Handling Standards

**TypeScript Errors:**
- ✅ Fix root cause (check API docs, package version) - never suppress with `@ts-ignore`
- ✅ Use `// eslint-disable-next-line` only with comment explaining WHY
- ❌ Don't blindly suppress - understand the error first

**ESLint Errors:**
- ✅ Use `unknown` instead of `any` for error handling
  ```typescript
  catch (error: unknown) {
    const msg = error instanceof Error ? error.message : 'Unknown error';
  }
  ```

## AI Assistant Autonomy Guidelines

**Execute autonomously when:** The task is clearly defined, you know the right approach, changes are isolated, you're following established patterns

**Ask for clarification when:** Multiple valid approaches exist, breaking changes are needed, cross-team coordination required, security/auth implications

**Suggest and execute when:** You see obvious improvements, refactoring would help, tests are missing, documentation is outdated

**Remember:** If it's clear what to do and you know the best approach, just do it. Operate with autonomy and confidence where the path is clear.

---

**This configuration is built for scale, clarity, and collaboration. Keep it clean, modular, and well-tested.** 🚀