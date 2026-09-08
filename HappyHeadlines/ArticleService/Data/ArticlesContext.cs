using ArticleService.Models;
using Microsoft.EntityFrameworkCore;

namespace ArticleService.Data
{
    public class ArticlesContext : DbContext
    {
        public ArticlesContext(DbContextOptions<ArticlesContext> options) 
        : base(options)
        {
        }

        public DbSet<Article> Articles { get; set; }
    }
}