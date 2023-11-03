using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Text;
using System.Security.Claims;
using Sonorus.AccountAPI.Data.Entities;
using System.Security.Cryptography;

namespace Sonorus.AccountAPI.Services;

public class TokenService {
    private readonly byte[] _key = Encoding.ASCII.GetBytes(Environment.GetEnvironmentVariable("SECRET_JWT")!);

    public string GenerateToken(User user) {
        JwtSecurityTokenHandler tokenHandler = new();
        SecurityTokenDescriptor tokenDescriptor = new() {
            Expires = DateTime.UtcNow.AddHours(1),
            SigningCredentials = new(
                key: new SymmetricSecurityKey(this._key),
                algorithm: SecurityAlgorithms.HmacSha256Signature
            ),
            Subject = new(
                new Claim[] {
                    new("UserId", user.UserId.ToString()!),
                    new("Fullname", user.Fullname),
                    new("Nickname", user.Nickname),
                    new("Email", user.Email),
                    new("Picture", user.Picture!)
                }
            )
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
                key: new SymmetricSecurityKey(this._key),
                algorithm: SecurityAlgorithms.HmacSha256Signature
            )
        };
        SecurityToken token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }

    public string GenerateRefreshToken() {
        byte[] randomNumber = new byte[32];
        using RandomNumberGenerator rng = RandomNumberGenerator.Create();
        rng.GetBytes(randomNumber);
        return Convert.ToBase64String(randomNumber);
    }
}