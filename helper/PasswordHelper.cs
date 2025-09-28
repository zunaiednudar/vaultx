using System;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;

namespace vaultx.cls
{
    public static class PasswordHelper
    {
        public static bool IsPasswordStrong(string password)
        {
            if (string.IsNullOrEmpty(password) || password.Length < 8) return false;
            if (!Regex.IsMatch(password, @"[A-Z]")) return false;
            if (!Regex.IsMatch(password, @"[a-z]")) return false;
            if (!Regex.IsMatch(password, @"\d")) return false;
            if (!Regex.IsMatch(password, @"[!@#$%^&*()_+\-=\[\]{};':""\\|,.<>?]")) return false;
            return true;
        }

        public static string HashPassword(string password)
        {
            if (string.IsNullOrEmpty(password)) throw new ArgumentException("Password cannot be null or empty");

            byte[] salt = new byte[32];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000))
            {
                byte[] hash = pbkdf2.GetBytes(32);
                byte[] hashBytes = new byte[64];
                Array.Copy(salt, 0, hashBytes, 0, 32);
                Array.Copy(hash, 0, hashBytes, 32, 32);
                return Convert.ToBase64String(hashBytes);
            }
        }

        public static bool VerifyPassword(string password, string storedHash)
        {
            if (string.IsNullOrEmpty(password) || string.IsNullOrEmpty(storedHash)) return false;
            try
            {
                byte[] hashBytes = Convert.FromBase64String(storedHash);
                if (hashBytes.Length != 64) return false;

                byte[] salt = new byte[32];
                byte[] hash = new byte[32];
                Array.Copy(hashBytes, 0, salt, 0, 32);
                Array.Copy(hashBytes, 32, hash, 0, 32);

                using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000))
                {
                    byte[] inputHash = pbkdf2.GetBytes(32);
                    for (int i = 0; i < 32; i++)
                    {
                        if (hash[i] != inputHash[i]) return false;
                    }
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }
    }
}