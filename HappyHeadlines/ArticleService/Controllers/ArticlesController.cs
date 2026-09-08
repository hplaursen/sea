using ArticleService.Models;
using ArticleService.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace ArticleService.Controllers;
[ApiController]
[Route("api/[controller]")]
public class ArticlesController : ControllerBase
{
    private readonly ArticlesRepository _articlesRepository;

    public ArticlesController(ArticlesRepository articlesRepository)
    {
        _articlesRepository = articlesRepository;
    }


    [HttpGet("{id}")]
    public async Task<IActionResult> GetArticle(int id)
    {
        var article = await _articlesRepository.GetArticleByIdAsync(id);
        if (article == null) return NotFound();

        return Ok(article);
    }

    [HttpPost]
    public async Task<IActionResult> CreateArticle(Article article)
    {
        var createdArticle = await _articlesRepository.CreateArticleAsync(article);
        return CreatedAtAction(nameof(GetArticle), new { id = createdArticle.Id }, createdArticle);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateArticle(int id, Article updatedArticle)
    {
        var article = await _articlesRepository.UpdateArticleAsync(id, updatedArticle);
        if (article == null) return NotFound();

        return Ok(article);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteArticle(int id)
    {
        var result = await _articlesRepository.DeleteArticleAsync(id);
        if (!result) return NotFound();

        return NoContent();
    }
}