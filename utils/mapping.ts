export const mapProject = (data: any): any => {
    if (!data) return data;
    if (Array.isArray(data)) return data.map(mapProject);

    return {
        id: data.id,
        serialNumber: data.serial_number || 0,
        customerId: data.customer_id,
        clientName: data.client_name,
        clientType: data.client_type,
        title: data.title,
        description: data.description,
        category: data.category,
        status: data.status,
        createdBy: data.created_by ?? data.createdBy ?? null,
        createdByName: data.created_by_name ?? data.createdByName ?? null,
        createdByEmail: data.created_by_email ?? data.createdByEmail ?? null,
        createdByUser: data.created_by_user ?? data.createdByUser ?? null,
        createDate: data.created_at ?? data.createDate ?? data.createdAt,
        deliveryDate: data.delivery_date ?? data.deliveryDate,
        price: Number(data.price),
        advanceAmount: Number((data.advance_amount ?? data.advanceAmount ?? 0) || 0),
        paidAmount: Number((data.paid_amount ?? data.paidAmount ?? 0) || 0),
        paymentStatus: data.payment_status ?? data.paymentStatus,
        paymentMethod: (data.payment_method ?? data.paymentMethod) || 'None',
        paymentDetails: data.payment_details ? (typeof data.payment_details === 'string' ? JSON.parse(data.payment_details) : data.payment_details) : undefined,
        posterCount: data.poster_count || 0,
        thumbnailCount: data.thumbnail_count || 0,
        bannerCount: data.banner_count || 0,
        transactionRef: data.transaction_ref,
        director: data.director,
        designerName: data.designer_name,
        assistantName: data.assistant_name,
        images: Array.isArray(data.images) ? data.images.map((img: any) => ({
            id: img.id,
            url: img.url,
            type: img.type
        })) : [],
        secureToken: data.secure_token,
        isVisibleOnPublic: Boolean(data.is_visible_on_public),
        showInAnimation: Boolean(data.show_in_animation),
        showInPrevious: Boolean(data.show_in_previous),
        downloadLink: data.drive_link || data.downloadLink || '',
        created_by: data.created_by || data.createdBy || ''
    };
};

export const mapCustomer = (data: any[]): any[] => {
    if (!Array.isArray(data)) return [];
    return data.map((c: any) => ({
        id: c.id,
        name: c.name,
        phone: c.phone || '',
        type: c.type,
        isActive: c.status ? c.status === 'Active' : (c.isActive ?? true),
        createdAt: c.joined_at || c.joinedAt || c.createdAt || new Date().toISOString(),
        profileImageUrl: c.profile_image_url || c.profileImageUrl || c.profileImageURL || ''
    }));
};

export const mapExpense = (data: any): any => {
    if (!data) return data;
    if (Array.isArray(data)) return data.map(mapExpense);

    return {
        id: data.id,
        reason: data.reason,
        amount: Number(data.amount),
        category: data.category,
        date: data.date
    };
};

export const prepareProjectPayload = (project: any): any => {
    return {
        id: project.id,
        title: project.title,
        customer_id: project.customerId,
        description: project.description,
        category: project.category,
        status: project.status,
        delivery_date: project.deliveryDate,
        price: project.price,
        advance_amount: project.advanceAmount,
        // payment_status and payment_method are intentionally omitted — the backend
        // auto-derives them from advance_amount / paid_amount / price. Sending them
        // from the form caused RULE B to interfere with advance edits.
        is_visible_on_public: project.isVisibleOnPublic ? 1 : 0,
        show_in_animation: project.showInAnimation ? 1 : 0,
        show_in_previous: project.showInPrevious ? 1 : 0,
        drive_link: project.downloadLink,
        designer_name: project.designerName,
        assistant_name: project.assistantName,
        images: project.images ? project.images.map((img: any) => ({ url: img.url, type: img.type })) : []
    };
};
