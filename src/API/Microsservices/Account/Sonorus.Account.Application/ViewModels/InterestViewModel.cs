using Sonorus.Account.Core.Enums;

namespace Sonorus.Account.Application.ViewModels;

public record InterestViewModel(long InterestId, string Key, string Value, InterestType Type);