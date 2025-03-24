using MediatR;
using Sonorus.Post.Application.ViewModels;

namespace Sonorus.Post.Application.Queries.GetPagedPosts;

public class GetPagedPostsQuery(long userId, string accessToken, int offset, int limit, bool contentByPreference) : IRequest<IEnumerable<PostViewModel>> {
    public long UserId { get; private set; } = userId;
    public string AccessToken { get; private set; } = accessToken;
    public int Offset { get; private set; } = offset;
    public int Limit { get; private set; } = limit;
    public bool ContentByPreference { get; private set; } = contentByPreference;
}