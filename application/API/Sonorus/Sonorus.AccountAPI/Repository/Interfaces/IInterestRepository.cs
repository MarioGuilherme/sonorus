using Sonorus.AccountAPI.Data;

namespace Sonorus.AccountAPI.Repository.Interfaces;

public interface IInterestRepository {
    Task<List<Interest>> GetAll();
}