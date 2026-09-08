using ArticleService.Data;
using ArticleService.Models;

namespace ArticleService.Repositories;
public class ArticlesRepository
{
    private readonly ArticlesContext _context;
    
    public ArticlesRepository(ArticlesContext context)
    {
        _context = context;
    }

    public async Task<Article> CreateArticleAsync(Article article)
    {
        _context.Articles.Add(article);
        await _context.SaveChangesAsync();
        return article;
    }

    public async Task<Article?> GetArticleByIdAsync(int id)
    {
        return await _context.Articles.FindAsync(id);
    }

    public async Task<Article?> UpdateArticleAsync(int id, Article updatedArticle)
    {
        var article = await _context.Articles.FindAsync(id);
        if (article == null) return null;

        article.Title = updatedArticle.Title;
        article.Content = updatedArticle.Content;
        article.PublishedAt = updatedArticle.PublishedAt;

        await _context.SaveChangesAsync();
        return article;
    }

    public async Task<bool> DeleteArticleAsync(int id)
    {
        var article = await _context.Articles.FindAsync(id);
        if (article == null) return false;

        _context.Articles.Remove(article);
        await _context.SaveChangesAsync();
        return true;
    }   
}


