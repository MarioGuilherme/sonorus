using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Text;
using System.Security.Claims;
using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Configuration;

public static class TokenService {
    public static string GenerateToken(User user) {
        byte[] key = Encoding.ASCII.GetBytes(Environment.GetEnvironmentVariable("SECRET_JWT")!);
        JwtSecurityTokenHandler tokenHandler = new();
        SecurityTokenDescriptor tokenDescriptor = new() {
            Expires = DateTime.UtcNow.AddHours(1),
            SigningCredentials = new(
                key: new SymmetricSecurityKey(key),
                algorithm: SecurityAlgorithms.HmacSha256Signature
            ),
            Subject = new(
                new Claim[] {
                    new(ClaimTypes.Name, user.FullName),
                    new(ClaimTypes.Name, user.Nickname),
                    new(ClaimTypes.Name, user.Email)
                }
            )
        };
        SecurityToken token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}