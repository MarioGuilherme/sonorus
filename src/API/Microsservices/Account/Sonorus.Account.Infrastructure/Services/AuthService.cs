using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Services;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace Sonorus.Account.Infrastructure.Services;

public class AuthService(IConfiguration configuration) : IAuthService {
    private readonly IConfiguration _configuration = configuration;

    public string GenerateRefreshToken() {
        byte[] randomNumber = new byte[32];
        using RandomNumberGenerator rng = RandomNumberGenerator.Create();
        rng.GetBytes(randomNumber);
        return Convert.ToBase64String(randomNumber);
    }

    public string GenerateToken(User user) {
        string issuer = this._configuration["Jwt:Issuer"]!;
        string audience = this._configuration["Jwt:Audience"]!;
        string key = this._configuration["Jwt:Secret"]!;

        SymmetricSecurityKey securityKey = new(Encoding.UTF8.GetBytes(key));
        JwtSecurityTokenHandler tokenHandler = new();
        SecurityTokenDescriptor tokenDescriptor = new() {
            Audience = audience,
            Issuer = issuer,
            Expires = DateTime.UtcNow.AddHours(1),
            SigningCredentials = new(securityKey, SecurityAlgorithms.HmacSha256Signature),
            Subject = new([
                new("UserId", user.UserId.ToString()!),
                new("Fullname", user.Fullname),
                new("Nickname", user.Nickname),
                new("Email", user.Email),
                new("Picture", user.Picture!)
            ])
        };

        SecurityToken token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }

    public string GenerateToken(IEnumerable<Claim> claims) {
        JwtSecurityTokenHandler tokenHandler = new();
        SecurityTokenDescriptor tokenDescriptor = new() {
            Expires = DateTime.UtcNow.AddHours(1),
            Subject = new ClaimsIdentity(claims),
            SigningCredentials = new(
                key: new SymmetricSecurityKey(Encoding.UTF8.GetBytes(this._configuration["Jwt:Secret"]!)),
                algorithm: SecurityAlgorithms.HmacSha256Signature
            )
        };
        SecurityToken token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}