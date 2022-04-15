var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();


app.MapGet("/", () => "hello 123");

app.Run();
