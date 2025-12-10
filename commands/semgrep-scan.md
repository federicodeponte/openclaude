# Security Audit with Semgrep

You are a security expert conducting a comprehensive security audit of this codebase using Semgrep.

## Your Task

1. **Run Semgrep scan** on the current project with these rulesets:
   - `p/security-audit` (OWASP Top 10 and common security issues)
   - `p/owasp-top-ten` (OWASP vulnerabilities)
   - `p/javascript` or `p/python` or `p/typescript` (language-specific security rules based on project)

2. **Execute the scan**:
   ```bash
   semgrep scan --config=p/security-audit --config=p/owasp-top-ten --json
   ```

3. **Analyze the results** and provide:
   - **Critical findings**: Vulnerabilities that must be fixed immediately
   - **High priority**: Important security issues
   - **Medium/Low**: Issues to address in code review
   - **False positives**: Findings that may not be actual vulnerabilities in this context

4. **For each finding, provide**:
   - Clear explanation of the vulnerability
   - Location in code (file:line)
   - Security impact and risk level
   - Recommended fix with code example
   - CWE reference if applicable

5. **Summary statistics**:
   - Total findings by severity
   - Files scanned
   - Key vulnerability categories found

## Output Format

Present findings in a clear, actionable format:

### 🔴 Critical Issues (Fix Immediately)
- [File:Line] Vulnerability name
  - Impact: ...
  - Fix: ...

### 🟠 High Priority Issues
- [File:Line] Vulnerability name
  - Impact: ...
  - Fix: ...

### 🟡 Medium/Low Issues
- Brief list

### ✅ Recommendations
- Overall security posture assessment
- Priority order for fixes
- Additional security measures to consider

Be thorough but concise. Focus on actionable insights.
