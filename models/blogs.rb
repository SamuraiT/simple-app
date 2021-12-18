require 'pry'
require "csv"

class Blog
  # hoge = Blog.where(title: 'hoge')
  # hoge.publish #=> 公開されます
  attr_accessor :body, :title, :attributes, :published_at
  FILENAME = "db/blog.csv"

  def initialize(title, body,published_at=nil)
    @title = title
    @body = body
    @published_at = published_at
  end

  def self.find(title, filename=Blog::FILENAME)
    blogs = BlogCollection.from_csv(filename)
    blogs.find(title)
  end
  def self.all(filename=Blog::FILENAME)
    BlogCollection.from_csv(filename)
  end

  def self.where(key,value, filename=Blog::FILENAME)
    blogs = BlogCollection.from_csv(filename)
    blogs.where(key, value)
  end

  def save(filename=Blog::FILENAME)
    CSV.open(filename,"a") do |row|
      row << attributes
    end
  end

  def publish(filename=Blog::FILENAME)
    blogs = Blog.all()
    blog, i= blogs.find_with_id(@title)
    @published_at = Date.today.to_s
    blogs.blogs[i] = self

    CSV.open(filename, "w") do |row|
      blogs.blogs.each do |blog|
        row << blog.attributes
      end
    end
  end

  def attributes
    [@title, @body,@published_at]
  end
end

class BlogCollection
  attr_accessor :blogs
  def initialize(blogs=[])
    @blogs = blogs
  end

  def self.from_csv(filename)
    blogs = []
    CSV.foreach(filename) do |title, body, published_at|
      blogs << Blog.new(title,body,published_at)
    end
    BlogCollection.new(blogs)
  end

  def append(blog)
    @blogs << blog
  end

  def find_with_id(title)
    found_blog = []
    @blogs.each_with_index do |blog,i|
      return blog, i if blog.title == title
    end

    raise "Not Found"
  end

  def find(title)
    found_blog = []
    @blogs.each do |blog|
      return blog if blog.title == title
    end

    raise "Not Found"
  end

  def where(key, value)
    found_blog = []
    @blogs.each do |blog|
      if blog[key].include?(val)
        found_blog << blog
      end
    end

    return puts("Not found") if found_blog.empty?

    found_blog
  end

  def [](i)
    @blogs
  end

  def first
    @blogs[0]
  end

  def last
    @blogs[-1]
  end
end
