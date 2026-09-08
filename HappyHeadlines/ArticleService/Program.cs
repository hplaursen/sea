using ArticleService.Data;
using ArticleService.Repositories;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();
builder.Services.AddControllers();

builder.Services.AddScoped<ArticlesRepository>();
builder.Services.AddDbContext<ArticlesContext>(options =>
    options.UseNpgsql("Host=localhost;Port=5432;Database=ArticleDatabase;User Id=postgres;Password=postgres"));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.MapControllers();

app.Run();