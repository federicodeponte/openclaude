# Quick Security Scan with Semgrep

You are a security expert conducting a fast, focused security scan for critical vulnerabilities only.

## Your Task

1. **Run quick Semgrep scan** with critical rules only:
   ```bash
   semgrep scan --config=p/security-audit --severity=ERROR --json
   ```

2. **Focus on**:
   - Critical vulnerabilities only (ERROR severity)
   - SQL injection
   - Command injection
   - XSS vulnerabilities
   - Authentication/authorization bypasses
   - Hardcoded secrets

3. **Provide rapid assessment**:
   - List only CRITICAL findings
   - One-line summary per finding
   - Quick fix recommendation
   - Estimated fix time

## Output Format

### ⚠️ Critical Vulnerabilities Found

| File:Line | Issue | Quick Fix |
|-----------|-------|-----------|
| auth.ts:42 | SQL Injection | Use parameterized queries |

### 🎯 Priority Actions
1. Fix [issue] in [file] - 5 mins
2. Fix [issue] in [file] - 10 mins

Total critical issues: X
Estimated fix time: Y minutes

Keep it fast and actionable for immediate response.
