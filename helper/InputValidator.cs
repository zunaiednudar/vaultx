using System;
using System.Text.RegularExpressions;

namespace vaultx.cls
{
    public static class InputValidator
    {
        public static bool IsValidEmail(string email)
        {
            if (string.IsNullOrWhiteSpace(email)) return false;
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                if (addr.Address != email) return false;
                string pattern = @"^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$";
                return Regex.IsMatch(email, pattern);
            }
            catch
            {
                return false;
            }
        }

        public static bool ContainsSqlInjection(string input)
        {
            if (string.IsNullOrEmpty(input)) return false;
            string[] patterns = {
                @"('|;|--|\b(select|insert|update|delete|drop|truncate|exec)\b)",
                @"union(.|\n)*select",
                @"exec(\s|\+)+(s|x)p\w+"
            };
            foreach (var p in patterns)
            {
                if (Regex.IsMatch(input, p, RegexOptions.IgnoreCase)) return true;
            }
            return false;
        }

        public static bool ContainsXSS(string input)
        {
            if (string.IsNullOrEmpty(input)) return false;
            string[] patterns = {
                @"<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>",
                @"javascript:",
                @"on\w+\s*="
            };
            foreach (var p in patterns)
            {
                if (Regex.IsMatch(input, p, RegexOptions.IgnoreCase)) return true;
            }
            return false;
        }

        public static string SanitizeInput(string input)
        {
            if (string.IsNullOrEmpty(input)) return string.Empty;
            string sanitized = Regex.Replace(input, @"<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>", "", RegexOptions.IgnoreCase);
            sanitized = Regex.Replace(sanitized, @"<[^>]*>", "");
            sanitized = sanitized.Replace("'", "''").Replace("\"", "&quot;").Replace("<", "&lt;").Replace(">", "&gt;");
            return sanitized.Trim();
        }

        public static bool IsValidAccountNumber(string accountNumber)
        {
            if (string.IsNullOrWhiteSpace(accountNumber)) return false;
            string clean = Regex.Replace(accountNumber, @"[\s\-]", "");
            return clean.Length >= 6 && clean.Length <= 20 && Regex.IsMatch(clean, @"^\d+$");
        }

        public static bool IsValidAmount(string amount, decimal minAmount = 0.01m, decimal maxAmount = 999999999.99m)
        {
            if (string.IsNullOrWhiteSpace(amount)) return false;
            if (!decimal.TryParse(amount, out decimal v)) return false;
            return v >= minAmount && v <= maxAmount;
        }
    }
}