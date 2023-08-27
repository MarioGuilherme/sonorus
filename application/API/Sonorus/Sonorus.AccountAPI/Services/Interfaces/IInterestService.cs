using Sonorus.AccountAPI.DTO;

namespace Sonorus.AccountAPI.Services.Interfaces;

public interface IInterestService {
    Task<List<InterestDTO>> GetAll();
}