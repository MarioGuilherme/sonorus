using Sonorus.Account.Core.Entities;
using System.Security.Claims;

namespace Sonorus.Account.Core.Services;

public interface IAuthService {
    public string GenerateRefreshToken();
    public string GenerateToken(User user);
    public string GenerateToken(IEnumerable<Claim> claims);
}