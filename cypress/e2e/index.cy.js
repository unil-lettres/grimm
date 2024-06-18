describe('index page', () => {
  beforeEach(() => {
    cy.visit('')
})

  it('should have Grimm in title', () => {
    cy.get('.tp-title > pb-i18n')
      .contains('Grimm')
  })

  it.skip('should show stories without selecting a language', () => {
    cy.get('.tp-title > pb-i18n')
      .contains('Grimm')
  })

  it.skip('should perform search over corpus', () => {
    cy.get('.tp-title > pb-i18n')
      .contains('Grimm')
  })

  it.skip('should switch languages', () => {
    cy.get('.tp-title > pb-i18n')
      .contains('Grimm')
  })

  describe('search facettes', () => {

    it.skip('should have working title search', () => {
      cy.get('.tp-title > pb-i18n')
        .contains('Grimm')
    })

    it.skip('should show languages', () => {
      cy.get('.tp-title > pb-i18n')
        .contains('Grimm')
    })

    it.skip('should show translators', () => {
      cy.get('.tp-title > pb-i18n')
        .contains('Grimm')
    })

    it.skip('should show century', () => {
      cy.get('.tp-title > pb-i18n')
        .contains('Grimm')
    })
  })

})