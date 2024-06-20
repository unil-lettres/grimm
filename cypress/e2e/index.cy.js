describe('index page', () => {
  beforeEach(() => {
    cy.visit('')
})

  it('should have Grimm in title', () => {
    cy.get('.tp-title > pb-i18n')
      .contains('Grimm')
  })

  it('should show at least two stories', () => {
    cy.get('#document-list')
      .find('.tale')
      .should('have.length.gt', 2)
  })

  it('should contain four search facets', () => {
    cy.get('.facet-dimension')
      .should('have.length', 4)
  })

  it('should display i18n selector', () => {
    cy.get('[name=lang]')
      .contains('Language')
  })

  it('should display project code in metadata', () => {
    cy.get('.metadata')
      .contains('ANR-15-IDEX-02')
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