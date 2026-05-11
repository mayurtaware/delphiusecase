using Microsoft.AspNetCore.Mvc;

namespace DemoApp.Controllers;

/// <summary>
/// Demo API Controller showcasing CRUD operations
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class DemoController : ControllerBase
{
    private static readonly List<DemoItem> Items = new()
    {
        new DemoItem { Id = 1, Name = "Welcome", Description = "Welcome to Delphi Demo App", CreatedAt = DateTime.UtcNow },
        new DemoItem { Id = 2, Name = "Azure Deployment", Description = "Running on Azure App Service", CreatedAt = DateTime.UtcNow }
    };

    private readonly ILogger<DemoController> _logger;

    public DemoController(ILogger<DemoController> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// Get all demo items
    /// </summary>
    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public ActionResult<IEnumerable<DemoItem>> GetAll()
    {
        _logger.LogInformation("Getting all demo items");
        return Ok(Items);
    }

    /// <summary>
    /// Get demo item by ID
    /// </summary>
    [HttpGet("{id}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult<DemoItem> GetById(int id)
    {
        _logger.LogInformation($"Getting demo item with ID: {id}");
        var item = Items.FirstOrDefault(i => i.Id == id);
        if (item is null)
            return NotFound(new { message = $"Item with ID {id} not found" });
        
        return Ok(item);
    }

    /// <summary>
    /// Create a new demo item
    /// </summary>
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public ActionResult<DemoItem> Create([FromBody] CreateDemoItemDto dto)
    {
        _logger.LogInformation($"Creating new demo item: {dto.Name}");
        
        if (string.IsNullOrWhiteSpace(dto.Name))
            return BadRequest(new { message = "Name is required" });

        var item = new DemoItem
        {
            Id = Items.Max(i => i.Id) + 1,
            Name = dto.Name,
            Description = dto.Description ?? string.Empty,
            CreatedAt = DateTime.UtcNow
        };

        Items.Add(item);
        return CreatedAtAction(nameof(GetById), new { id = item.Id }, item);
    }

    /// <summary>
    /// Update demo item
    /// </summary>
    [HttpPut("{id}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult<DemoItem> Update(int id, [FromBody] UpdateDemoItemDto dto)
    {
        _logger.LogInformation($"Updating demo item with ID: {id}");
        
        var item = Items.FirstOrDefault(i => i.Id == id);
        if (item is null)
            return NotFound(new { message = $"Item with ID {id} not found" });

        item.Name = dto.Name ?? item.Name;
        item.Description = dto.Description ?? item.Description;

        return Ok(item);
    }

    /// <summary>
    /// Delete demo item
    /// </summary>
    [HttpDelete("{id}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public IActionResult Delete(int id)
    {
        _logger.LogInformation($"Deleting demo item with ID: {id}");
        
        var item = Items.FirstOrDefault(i => i.Id == id);
        if (item is null)
            return NotFound(new { message = $"Item with ID {id} not found" });

        Items.Remove(item);
        return NoContent();
    }

    /// <summary>
    /// Get item count
    /// </summary>
    [HttpGet("count")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public ActionResult<int> GetCount()
    {
        _logger.LogInformation("Getting demo items count");
        return Ok(Items.Count);
    }
}

/// <summary>
/// Demo Item model
/// </summary>
public class DemoItem
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
}

/// <summary>
/// DTO for creating demo items
/// </summary>
public class CreateDemoItemDto
{
    public required string Name { get; set; }
    public string? Description { get; set; }
}

/// <summary>
/// DTO for updating demo items
/// </summary>
public class UpdateDemoItemDto
{
    public string? Name { get; set; }
    public string? Description { get; set; }
}
