using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Text;
using System.Security.Claims;
using Sonorus.AccountAPI.Data;

namespace Sonorus.AccountAPI.Services;

public class TokenService {
    public string GenerateToken(User user) {
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
                    new("IdUser", user.IdUser.ToString()!),
                    new("Fullname", user.Fullname),
                    new("Nickname", user.Nickname),
                    new("Email", user.Email),
                    new("Picture", user.Picture)
                }
            )
        };
        SecurityToken token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}