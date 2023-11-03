using Sonorus.AccountAPI.Data.Entities;

namespace Sonorus.AccountAPI.Repository.Interfaces;

public interface IInterestRepository {
    Task<List<Interest>> GetAllAsync();
    Task<long> CreateAsync(Interest interest);
}