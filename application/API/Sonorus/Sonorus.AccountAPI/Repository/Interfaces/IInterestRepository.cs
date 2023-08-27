using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Repository.Interfaces;

public interface IInterestRepository {
    Task<List<Interest>> GetAll();
}