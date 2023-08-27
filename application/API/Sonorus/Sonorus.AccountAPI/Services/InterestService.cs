using AutoMapper;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Repository.Interfaces;
using Sonorus.AccountAPI.Services.Interfaces;

namespace Sonorus.AccountAPI.Services;

public class InterestService : IInterestService {
    private readonly IInterestRepository _interestRepository;
    private readonly IMapper _mapper;

    public InterestService(IInterestRepository interestRepository, IMapper mapper) {
        this._interestRepository = interestRepository;
        this._mapper = mapper;
    }

    public async Task<List<InterestDTO>> GetAll() {
        List<Interest> interests = await this._interestRepository.GetAll();
        return this._mapper.Map<List<InterestDTO>>(interests);
    }
}