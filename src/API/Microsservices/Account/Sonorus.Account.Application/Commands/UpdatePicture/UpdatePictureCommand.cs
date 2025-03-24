using MediatR;
using Microsoft.AspNetCore.Http;

namespace Sonorus.Account.Application.Commands.UpdatePicture;

public class UpdatePictureCommand(long userId, IFormFile picture) : IRequest<string> {
    public long UserId { get; private set; } = userId;
    public IFormFile Picture { get; private set; } = picture;
}