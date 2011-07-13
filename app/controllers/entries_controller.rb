class EntriesController < ApplicationController

  # GET /entries
  # GET /entries.json
  def index
    g = Group.all(:include => :entries)
    @groups = g.reject{|group| group.entries.empty? }
    @ens = g.map{|group| {name: group.name, id: group.id, entries: group.entries} }
    @ens.unshift({entries: Entry.all(conditions: {group_id: nil}), id: "-"})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {groups: @groups, sections: @ens} }
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  # def show
  #   @entry = Entry.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @entry }
  #   end
  # end

  # GET /entries/new
  # GET /entries/new.json
  # def new
  #   @entry = Entry.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @entry }
  #   end
  # end

  # GET /entries/1/edit
  # def edit
  #   @entry = Entry.find(params[:id])
  # end

  # POST /entries
  # POST /entries.json
  def create
    if (a = params.delete(:group))
      params[:entry][:group_id] = set_group(a)
    end

    @entry = Entry.new(params[:entry])

    respond_to do |format|
      if @entry.save
        #format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.html { 'Entry was successfully created.' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { 'Entry was not successfully created.' }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update
    @entry = Entry.find(params[:id])

    if (a = params.delete(:group))
      params[:entry][:group_id] = set_group(a)
    end

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        format.html { 'Entry was successfully updated.' }
        format.json { head :ok }
      else
        format.html { 'Foo' }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url }
      format.json { head :ok }
    end
  end

  private

  def set_group(str)
    case str
    when /^add:(.+)$/
      Group.create(name: $1).id
    when "-"
      nil
    else
      Group.find(str.to_i).id
    end
  end
end
