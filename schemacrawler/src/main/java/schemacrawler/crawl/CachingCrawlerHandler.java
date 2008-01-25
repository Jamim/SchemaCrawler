/* 
 *
 * SchemaCrawler
 * http://sourceforge.net/projects/schemacrawler
 * Copyright (c) 2000-2008, Sualeh Fatehi.
 *
 * This library is free software; you can redistribute it and/or modify it under the terms
 * of the GNU Lesser General Public License as published by the Free Software Foundation;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along with this
 * library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 */

package schemacrawler.crawl;


import schemacrawler.schema.DatabaseInfo;
import schemacrawler.schema.JdbcDriverInfo;
import schemacrawler.schema.Procedure;
import schemacrawler.schema.Schema;
import schemacrawler.schema.Table;

/**
 * Caches a crawled schema internally.
 * 
 * @author sfatehi
 */
public final class CachingCrawlerHandler
  implements CrawlHandler
{

  private final MutableSchema schema;
  private final SchemaInfoLevel infoLevel;

  /**
   * Creates a new caching crawl handler.
   */
  public CachingCrawlerHandler()
  {
    this("", null);
  }

  /**
   * Creates a new caching crawl handler.
   * 
   * @param catalogName
   *        Catalog name.
   * @param infoLevel
   *        Schema information level.
   */
  public CachingCrawlerHandler(final String catalogName,
                               final SchemaInfoLevel infoLevel)
  {
    schema = new MutableSchema(catalogName, "schema", "schema");
    if (infoLevel == null)
    {
      this.infoLevel = SchemaInfoLevel.maximum();
    }
    else
    {
      this.infoLevel = infoLevel;
    }
  }

  /**
   * @see CrawlHandler#begin()
   */
  public void begin()
    throws SchemaCrawlerException
  {
    // do nothing
  }

  /**
   * @see CrawlHandler#end()
   */
  public void end()
    throws SchemaCrawlerException
  {
    // do nothing
  }

  /**
   * Column info level.
   * 
   * @return Column info level
   * @see CrawlHandler#getInfoLevelHint()
   */
  public SchemaInfoLevel getInfoLevelHint()
  {
    return infoLevel;
  }

  /**
   * Gets the entire schema.
   * 
   * @return Schema
   */
  public Schema getSchema()
  {
    return schema;
  }

  /**
   * @see CrawlHandler#handle(DatabaseInfo)
   */
  public void handle(final DatabaseInfo databaseInfo)
  {
    schema.setDatabaseInfo(databaseInfo);
  }

  /**
   * {@inheritDoc}
   * 
   * @see schemacrawler.crawl.CrawlHandler#handle(schemacrawler.schema.JdbcDriverInfo)
   */
  public void handle(final JdbcDriverInfo driverInfo)
  {
    schema.setJdbcDriverInfo(driverInfo);
  }

  /**
   * Provides information on the database schema.
   * 
   * @param procedure
   *        Procedure metadata.
   */
  public void handle(final Procedure procedure)
  {
    schema.addProcedure((MutableProcedure) procedure);
  }

  /**
   * Provides information on the database schema.
   * 
   * @param table
   *        Table metadata.
   */
  public void handle(final Table table)
  {
    schema.addTable((MutableTable) table);
  }

}
