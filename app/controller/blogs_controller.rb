class BlogsController < ControllerHelper
  def index
    blogs_table_html =  Blog.all.blogs.map do |blog|
      table_template(blog.title)
    end.join("\n")

    render 'index', {tables: blogs_table_html}
  end

  def new
    render 'new'
  end

  def show
    target_title = @path.scan(/\/blogs\/(\w*)/).flatten.first
    begin
    blog = Blog.find(target_title)
      render 'show', {
        title: blog.title,
        body: blog.body,
        published_at: blog.published_at,
      }

    rescue RuntimeError => e
      render '404', {target_title: target_title}, 404
    end
  end

  def create
    data = form_data
    blog = Blog.new(data["title"], data["body"])
    blog.save

    render 'create', {title: blog.title}
  end

  def publish
    target_title = @path.scan(/\/blogs\/(\w*)\/publish/).flatten.first
    blog = Blog.find(target_title)
    blog.publish

    render 'published', {title: blog.title}
  end

  def table_template(title)
    <<-END_TABLE
      <tr>
        <td><a href='/blogs/#{title.strip}'>#{title}</a></td>
      </tr>
    END_TABLE
  end
end
