
class UserController < ControllerHelper
  def index
    users_table_html =  User.all.users.map do |user|
      table_template(user.name)
    end.join("\n")

    render 'index', {tables: users_table_html}
  end

  def new
    render 'new'
  end

  def show
    target_name = @path.scan(/\/users\/(\w*)/).flatten.first
    begin
      user = User.find(target_name)
      render 'show', {
        name: user.name,
        email: user.email,
        tel: user.tel
      }

    rescue RuntimeError => e
      render '404', {target_name: target_name}, 404
    end
  end

  def create
    data = form_data
    user = User.new(data["name"], data["email"], "", "")
    user.save

    render 'create', {name: user.name}
  end

  def table_template(name)
    <<-END_TABLE
      <tr>
        <td><a href='/users/#{name.strip}'>#{name}</a></td>
      </tr>
    END_TABLE
  end
end
