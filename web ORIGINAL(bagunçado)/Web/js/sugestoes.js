function removerSugestao(id) {
        const card = document.getElementById(id);
        card.style.opacity = '0';
        card.style.transform = 'scale(0.9)';
        
        setTimeout(() => {
            card.remove();
            Swal.fire({
                title: 'Removido!',
                text: 'A sua sugestão foi retirada.',
                icon: 'success',
                confirmButtonColor: '#7066e0',
                background: '#1e1a2d',
                color: '#fff'
            });
        }, 300);
    }