namespace Sonorus.Account.Application.Commands.AssociateCollectionOfInterests;

public class AssociateCollectionOfInterestsInputModel(IEnumerable<InterestInputModel> interests) {
    public IEnumerable<InterestInputModel> Interests { get; private set; } = interests;
}