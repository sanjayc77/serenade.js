{Serenade} = require '../../src/serenade'

describe 'If', ->
  beforeEach ->
    @setupDom()

  it 'shows the content if the model value is truthy', ->
    model = { valid: true, visible: "true" }

    @render '''
      ul
        - if @valid
          li[id="valid"]
        - if @visible
          li[id="visible"]
    ''', model
    expect(@body).toHaveElement('ul > li#valid')
    expect(@body).toHaveElement('ul > li#visible')

  it 'can have multiple children', ->
    model = { valid: true, visible: "true" }

    @render '''
      ul
        - if @valid
          li[id="valid"]
          li[id="visible"]
          li[id="monkey"]
    ''', model
    expect(@body).toHaveElement('ul > li#valid')
    expect(@body).toHaveElement('ul > li#visible')
    expect(@body).toHaveElement('ul > li#monkey')

  it 'does not show the content if the model value is falsy', ->
    model = { valid: false, visible: 0 }

    @render '''
      ul
        - if @valid
          li[id="valid"]
        - if @visible
          li[id="visible"]
    ''', model
    expect(@body).not.toHaveElement('ul > li#valid')
    expect(@body).not.toHaveElement('ul > li#visible')

  it 'updates the existence of content based on model value truthiness', ->
    model = new Serenade.Model(valid: false, visible: 0)

    @render '''
      ul
        - if @valid
          li[id="valid"]
        - if @visible
          li[id="visible"]
    ''', model
    expect(@body).not.toHaveElement('ul > li#valid')
    expect(@body).not.toHaveElement('ul > li#visible')
    model.set(valid: "yes")
    expect(@body).toHaveElement('ul > li#valid')
    expect(@body).not.toHaveElement('ul > li#visible')
    model.set(valid: "", visible: "Cool")
    expect(@body).not.toHaveElement('ul > li#valid')
    expect(@body).toHaveElement('ul > li#visible')
    model.set(valid: "Blah", visible: {})
    expect(@body).toHaveElement('ul > li#valid')
    expect(@body).toHaveElement('ul > li#visible')

  it 'peacefully coexists with collections', ->
    model = new Serenade.Model(items: [{ valid: true, name: 'foo' }, { name: 'bar' }])
    @render '''
      ul
        - collection @items
          - if @valid
            li[id=@name]
    ''', model
    expect(@body).toHaveElement('ul > li#foo')
    expect(@body).not.toHaveElement('ul > li#bar')

  it 'shows the content if the models type value is "photo"', ->
    model = { type: "photo", visible: 1 }

    @render '''
      ul
        - if @type "photo"
          li[id="valid"]
        - if @visible "1"
          li[id="visible"]
    ''', model
    expect(@body).toHaveElement('ul > li#valid')
    expect(@body).toHaveElement('ul > li#visible')

  it 'can have multiple children', ->
    model = {  type: "photo", visible: "true" }

    @render '''
      ul
        - if @type "photo"
          li[id="valid"]
          li[id="visible"]
          li[id="monkey"]
    ''', model
    expect(@body).toHaveElement('ul > li#valid')
    expect(@body).toHaveElement('ul > li#visible')
    expect(@body).toHaveElement('ul > li#monkey')

  it 'does not show the content if the model value is different', ->
    model = { type: "post", visible: 0 }

    @render '''
      ul
        - if @type "photo"
          li[id="valid"]
        - if @visible "1"
          li[id="visible"]
    ''', model
    expect(@body).not.toHaveElement('ul > li#valid')
    expect(@body).not.toHaveElement('ul > li#visible')

  it 'updates the existence of content based on model value match', ->
    model = new Serenade.Model(type: "post", visible: 0)

    @render '''
      ul
        - if @type "photo"
          li[id="valid"]
        - if @visible "1"
          li[id="visible"]
    ''', model
    expect(@body).not.toHaveElement('ul > li#valid')
    expect(@body).not.toHaveElement('ul > li#visible')
    model.set(type: "photo")
    expect(@body).toHaveElement('ul > li#valid')
    expect(@body).not.toHaveElement('ul > li#visible')
    model.set(type: "", visible: 1)
    expect(@body).not.toHaveElement('ul > li#valid')
    expect(@body).toHaveElement('ul > li#visible')
    model.set(type: "photo", visible: 1)
    expect(@body).toHaveElement('ul > li#valid')
    expect(@body).toHaveElement('ul > li#visible')

  it 'peacefully coexists with collections', ->
    model = new Serenade.Model(items: [{ type: "photo", name: 'foo' }, { name: 'bar' }])
    @render '''
      ul
        - collection @items
          - if @type "photo"
            li[id=@name]
    ''', model
    expect(@body).toHaveElement('ul > li#foo')
    expect(@body).not.toHaveElement('ul > li#bar')
