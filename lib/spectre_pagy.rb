require 'pagy/extras/shared'

class Pagy
  module Frontend
    def pagy_spectre_nav(pagy)
      link, p_prev, p_next = pagy_link_proc(pagy), pagy.prev, pagy.next

      html = EMPTY + (p_prev ? %(<li class="page-item">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li> )
                             : %(<li class="page-item disabled">#{link.call p_prev, pagy_t('pagy.nav.prev')}</li> ))
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(<li class="page-item">#{link.call item}</li> )           # page link
                elsif item.is_a?(String) ; %(<li class="page-item active">#{link.call item}</li> )    # current page
                elsif item == :gap       ; %(<li class="page-item">#{pagy_t('pagy.nav.gap')}</li> )   # page gap
                end
      end
      html << (p_next ? %(<li class="page-item">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
                      : %(<li class="page-item disabled">#{link.call p_next, pagy_t('pagy.nav.next')}</li>))
      %(<ul class="pagy-nav pagination" role="navigation" aria-label="pager">#{html}</nav>)
    end
  end
end
